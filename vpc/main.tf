# Cấu hình AWS provider
provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------------------------------------------------------
# ĐỊNH NGHĨA MẠNG VPC
# --------------------------------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# --------------------------------------------------------------------------------------------------
# INTERNET GATEWAY (Để Public Subnet ra ngoài Internet)
# --------------------------------------------------------------------------------------------------
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# --------------------------------------------------------------------------------------------------
# PUBLIC SUBNETS (Nơi đặt Load Balancer)
# --------------------------------------------------------------------------------------------------
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name                                              = "${var.project_name}-public-subnet-${count.index + 1}"
    "kubernetes.io/role/elb"                          = "1"      # Tag cho Public Load Balancer
    "kubernetes.io/cluster/${var.project_name}-cluster" = "shared" # Tag để EKS nhận diện subnet này thuộc về nó
  }
}

# ROUTE TABLE cho Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Liên kết Route Table với Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# --------------------------------------------------------------------------------------------------
# PRIVATE SUBNETS (Nơi đặt EKS Worker Nodes)
# --------------------------------------------------------------------------------------------------
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name                                              = "${var.project_name}-private-subnet-${count.index + 1}"
    "kubernetes.io/cluster/${var.project_name}-cluster" = "shared" # Tag cần thiết cho EKS
    "kubernetes.io/role/internal-elb"                 = "1"      # Tag cần thiết cho Internal Load Balancer
  }
}

# ROUTE TABLE cho Private Subnets
resource "aws_route_table" "private" {
  count  = length(var.private_subnet_cidrs)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  }
}

# Liên kết Route Table với Private Subnets
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# --------------------------------------------------------------------------------------------------
# NAT GATEWAY (Để Private Subnet ra ngoài Internet)
# --------------------------------------------------------------------------------------------------
resource "aws_eip" "nat" {
  count = length(var.public_subnet_cidrs)
  domain   = "vpc"
}

resource "aws_nat_gateway" "main" {
  count         = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.project_name}-nat-gateway-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.main]
}
