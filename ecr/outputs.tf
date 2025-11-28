output "auth_service_ecr_repo_url" {
  description = "URL của ECR repository cho Auth Service"
  value       = aws_ecr_repository.auth_service.repository_url
}

output "discovery_service_ecr_repo_url" {
  description = "URL của ECR repository cho Discovery Service"
  value       = aws_ecr_repository.discovery_service.repository_url
}

output "interaction_service_ecr_repo_url" {
  description = "URL của ECR repository cho Interaction Service"
  value       = aws_ecr_repository.interaction_service.repository_url
}

output "frontend_ecr_repo_url" {
  description = "URL của ECR repository cho Frontend"
  value       = aws_ecr_repository.frontend.repository_url
}
