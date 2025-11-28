variable "aws_region" {
  default = "ap-southeast-1"
}

variable "project_name" {
  default = "scoutli"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "db_username" {
  description = "Database master username"
  type        = string
  default     = "scoutli_admin"
}

variable "db_password" {
  description = "Database master password"
  type        = string
  sensitive   = true
}
