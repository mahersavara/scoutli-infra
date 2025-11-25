output "cluster_endpoint" {
  description = "Điểm cuối (endpoint) của EKS Kubernetes API server."
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_certificate_authority_data" {
  description = "Dữ liệu chứng chỉ (CA) đã được mã hóa base64 để giao tiếp với cluster."
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_name" {
  description = "Tên của cụm EKS."
  value       = aws_eks_cluster.main.name
}
