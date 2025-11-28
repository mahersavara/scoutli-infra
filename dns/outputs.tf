output "frontend_www_dns_name" {
  description = "DNS Name cho Frontend (www)"
  value       = aws_route53_record.frontend_www.fqdn
}

output "argocd_ui_dns_name" {
  description = "DNS Name cho ArgoCD UI"
  value       = aws_route53_record.argocd_ui.fqdn
}
