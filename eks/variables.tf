variable "aws_region" {
  description = "Khu vực AWS"
  type        = string
  default     = "ap-southeast-1"
}

variable "cluster_name" {
  description = "Tên cho cụm EKS"
  type        = string
  default     = "scoutli-cluster"
}

# --------------------------------------------------------------
# CÁC BIẾN NÀY CẦN LẤY TỪ OUTPUT CỦA BƯỚC 1 (VPC)
# --------------------------------------------------------------
variable "vpc_id" {
  description = "ID của VPC để triển khai EKS"
  type        = string
}

variable "private_subnet_ids" {
  description = "Danh sách ID của các private subnet cho worker nodes"
  type        = list(string)
}

# --------------------------------------------------------------
# Cấu hình cho Worker Nodes
# --------------------------------------------------------------
variable "node_instance_type" {
  description = "Loại máy chủ cho các worker node"
  type        = string
  default     = "t3.medium"
}

variable "node_group_desired_size" {
  description = "Số lượng worker node mong muốn"
  type        = number
  default     = 2
}

variable "node_group_min_size" {
  description = "Số lượng worker node tối thiểu"
  type        = number
  default     = 1
}

variable "node_group_max_size" {
  description = "Số lượng worker node tối đa"
  type        = number
  default     = 3
}
