variable "aws_region" {
  description = "Khu vực AWS để triển khai tài nguyên"
  type        = string
  default     = "ap-southeast-1" # Ví dụ: Singapore
}

variable "project_name" {
  description = "Tên dự án, dùng để đặt tên cho các tài nguyên"
  type        = string
  default     = "scoutli"
}

variable "vpc_cidr" {
  description = "Dải địa chỉ IP cho toàn bộ VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Danh sách các Availability Zone để triển khai Subnet"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
}

variable "public_subnet_cidrs" {
  description = "Danh sách các dải IP cho Public Subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Danh sách các dải IP cho Private Subnet"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}