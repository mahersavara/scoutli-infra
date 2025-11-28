terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Cấu hình Helm Provider với đường dẫn tuyệt đối
provider "helm" {
  kubernetes {
    config_path = "C:/Users/EKHUATL5J/.kube/config"
  }
}

# --------------------------------------------------------------------------------------------------
# 1. CÀI ĐẶT ARGOCD
# --------------------------------------------------------------------------------------------------
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.7.0"
  timeout          = 900

  values = [
    yamlencode({
      server = {
        service = {
          type = "LoadBalancer"
        }
        extraArgs = [
          "--insecure",
        ]
      }
    })
  ]
}

# --------------------------------------------------------------------------------------------------
# 2. CÀI ĐẶT AWS LOAD BALANCER CONTROLLER
# --------------------------------------------------------------------------------------------------

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "tls_certificate" "eks" {
  url = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "load_balancer_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_policy" "load_balancer_controller" {
  name        = "AWSLoadBalancerControllerIAMPolicy-${var.cluster_name}"
  policy      = file("${path.module}/iam_policy.json")
}

resource "aws_iam_role" "load_balancer_controller" {
  name               = "AmazonEKSLoadBalancerControllerRole-${var.cluster_name}"
  assume_role_policy = data.aws_iam_policy_document.load_balancer_controller_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "load_balancer_controller" {
  policy_arn = aws_iam_policy.load_balancer_controller.arn
  role       = aws_iam_role.load_balancer_controller.name
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.11.0"
  timeout    = 900

  values = [
    yamlencode({
      clusterName = var.cluster_name
      vpcId       = "vpc-00d780d7a2e83c288" # FIX: Truyền VPC ID trực tiếp để tránh lỗi IMDS
      serviceAccount = {
        create = true
        name   = "aws-load-balancer-controller"
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.load_balancer_controller.arn
        }
      }
    })
  ]

  depends_on = [
    aws_iam_role_policy_attachment.load_balancer_controller
  ]
}