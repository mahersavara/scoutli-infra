variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-southeast-1"
}

variable "cluster_name" {
  description = "Tên của EKS Cluster để cài đặt addons vào"
  type        = string
  default     = "scoutli-cluster"
}