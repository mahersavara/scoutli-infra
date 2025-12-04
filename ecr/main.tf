# Cấu hình AWS provider
provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------------------------------------------------------
# ECR REPOSITORIES (Nơi chứa Docker Images)
# --------------------------------------------------------------------------------------------------

# Repository cho Auth Service
resource "aws_ecr_repository" "auth_service" {
  name                 = "${var.project_name}-auth-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = var.project_name
    Service = "auth-service"
  }
}

# Repository cho Discovery Service
resource "aws_ecr_repository" "discovery_service" {
  name                 = "${var.project_name}-discovery-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = var.project_name
    Service = "discovery-service"
  }
}

# Repository cho Interaction Service
resource "aws_ecr_repository" "interaction_service" {
  name                 = "${var.project_name}-interaction-service"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = var.project_name
    Service = "interaction-service"
  }
}

# Repository cho Frontend
resource "aws_ecr_repository" "frontend" {
  name                 = "${var.project_name}-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Project = var.project_name
    Service = "frontend"
  }
}
