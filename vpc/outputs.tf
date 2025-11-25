output "vpc_id" {
  description = "ID của VPC vừa được tạo"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Danh sách ID của các Public Subnet"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Danh sách ID của các Private Subnet"
  value       = aws_subnet.private[*].id
}
