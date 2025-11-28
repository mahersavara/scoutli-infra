provider "aws" {
  region = var.aws_region
}

# Tạo Hosted Zone cho domain
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# --------------------------------------------------------------------------------------------------
# Cấu hình DNS cho Frontend (www.journeywriter.space)
# --------------------------------------------------------------------------------------------------
resource "aws_route53_record" "frontend_www" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300 # Thời gian tồn tại của bản ghi

  records = [var.ingress_lb_hostname] # Trỏ trực tiếp đến hostname của Load Balancer
}

# --------------------------------------------------------------------------------------------------
# Cấu hình DNS cho ArgoCD UI (argocd.journeywriter.space)
# --------------------------------------------------------------------------------------------------
resource "aws_route53_record" "argocd_ui" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "argocd.${var.domain_name}"
  type    = "CNAME"
  ttl     = 300

  records = [var.ingress_lb_hostname] # Trỏ trực tiếp đến hostname của Load Balancer
}