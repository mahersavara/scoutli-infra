variable "aws_region" {
  description = "Khu vực AWS"
  type        = string
  default     = "ap-southeast-1"
}

variable "domain_name" {
  description = "Tên miền gốc (root domain) của bạn"
  type        = string
  default     = "journeywriter.space" # Thay bằng tên miền của bạn
}

variable "ingress_lb_hostname" {
  description = "Hostname của NGINX Ingress Load Balancer"
  type        = string
}

variable "ingress_lb_zone_id" {
  description = "Hosted Zone ID của NGINX Ingress Load Balancer"
  type        = string
}
