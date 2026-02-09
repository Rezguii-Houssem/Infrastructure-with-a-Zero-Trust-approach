🚀 The Alpha Project: Secure AWS Infrastructure-as-Code

A production-ready Terraform project that deploys a fully private, secure EC2 environment managed via AWS Systems Manager (SSM). This project demonstrates advanced IaC principles including modular design, remote state locking, and multi-environment workspace management.

🏗️ Architecture Overview

The infrastructure is designed with a Zero-Trust approach:

Private Network: The EC2 instance resides in a private subnet with no Public IP and no Internet Gateway.

Secure Access: Management is handled via AWS Systems Manager (SSM) using VPC Interface Endpoints, eliminating the need for SSH keys or Bastion hosts.

Hybrid Connectivity: Uses S3 Gateway Endpoints for high-performance, private access to AWS S3.

🛠️ Professional Features
Modular Design: Separated into network and compute modules for reusability and clean separation of concerns.

Remote State & Locking: State is stored in an S3 bucket (versioned/encrypted) with DynamoDB for execution locking to prevent state corruption.

Multi-Environment (Workspaces): Uses Terraform Workspaces (dev, prod) and Map lookups to manage different environments from a single codebase.

Dynamic Data Sources: Automatically fetches the latest Amazon Linux 2023 AMI based on the deployment region, ensuring the environment is always up-to-date.

Security Guardrails: Includes a custom terraform_data precondition to prevent accidental deployments to the default workspace.

📂 Project Structure
Plaintext
.
├── main.tf            # Root module: Wiring modules and safety guards
├── variables.tf       # Environment-specific maps (Dev/Prod)
├── provider.tf        # AWS Provider & Remote Backend config
├── module/
│   ├── network/       # VPC, Subnets, SG, Endpoints
│   └── compute/       # EC2, IAM Roles, Instance Profiles
└── terraform.tfvars   # (Optional) Value overrides

🚀 Getting Started
1. Prerequisites
AWS CLI configured with SSO or IAM credentials.

Terraform v1.5+ installed.

An S3 bucket and DynamoDB table created for the backend (refer to bootstrap.tf).

2. Initialization & Workspace Setup
Bash
# Initialize and migrate local state to S3
terraform init

# Create and switch to the development environment
terraform workspace new dev
terraform workspace select dev
3. Deployment
Bash
# Preview changes
terraform plan

# Deploy infrastructure
terraform apply
4. Verification
Log in to the AWS Console.

Navigate to Systems Manager > Fleet Manager.

Verify the instance is Online.

Use Node Actions > Start Terminal Session to access the instance securely.

🧹 Cleanup
To avoid ongoing costs (especially for VPC Endpoints), destroy the environment when finished:

Bash
terraform workspace select dev
terraform destroy