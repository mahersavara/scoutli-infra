# Scoutli Infrastructure (Terraform)

This repository contains the **Infrastructure as Code (IaC)** for the Scoutli project, using [Terraform](https://www.terraform.io/) to provision resources on **AWS**.

## Architecture Overview

The infrastructure is designed for high availability and security, spanning **3 Availability Zones** in the `ap-southeast-1` region.

*   **VPC:** Custom Virtual Private Cloud (`10.0.0.0/16`).
*   **Subnets:**
    *   **3 Public Subnets:** For Load Balancers and NAT Gateways.
    *   **3 Private Subnets:** For EKS Worker Nodes and Databases (secure, no direct internet access).
*   **Compute:** Amazon EKS Cluster (Control Plane + Worker Node Group).
*   **Networking:** Internet Gateway, NAT Gateways, Route Tables.

## Directory Structure

```
.
├── eks/                # Terraform configuration for EKS Cluster
│   ├── main.tf         # Core logic for EKS and Node Groups
│   ├── variables.tf    # Input variables
│   ├── outputs.tf      # Output values (Cluster Endpoint, etc.)
│   └── terraform.tfvars# Configuration values (e.g., instance types)
├── vpc/                # Terraform configuration for VPC Networking
│   ├── main.tf         # Core logic for VPC, Subnets, IGW, NAT
│   ├── variables.tf    # Input variables
│   └── outputs.tf      # Output values (VPC ID, Subnet IDs)
└── .gitignore
```

## Prerequisites

*   [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.0+) installed.
*   [AWS CLI](https://aws.amazon.com/cli/) installed and configured with valid credentials (`aws configure`).

## Usage

### Step 1: Provision Network (VPC)

1.  Navigate to the VPC directory:
    ```bash
    cd vpc
    ```
2.  Initialize Terraform:
    ```bash
    terraform init
    ```
3.  Review the plan:
    ```bash
    terraform plan -out=tfplan
    ```
4.  Apply the configuration:
    ```bash
    terraform apply "tfplan"
    ```

### Step 2: Provision Cluster (EKS)

1.  Navigate to the EKS directory:
    ```bash
    cd ../eks
    ```
2.  **Important:** Update `terraform.tfvars` with the `vpc_id` and `private_subnet_ids` output from Step 1.
3.  Initialize and Apply:
    ```bash
    terraform init
    terraform plan -out=tfplan
    terraform apply "tfplan"
    ```

## Cost Warning

Running this infrastructure incurs costs on AWS (EKS Control Plane, NAT Gateways, EC2 instances). Remember to run `terraform destroy` when not in use to avoid unexpected charges.
