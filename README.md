<![CDATA[<div align="center">

# 🚀 The Alpha Project

### Secure AWS Infrastructure-as-Code

![Terraform](https://img.shields.io/badge/Terraform-v1.5+-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![SSM](https://img.shields.io/badge/Access-SSM_Only-232F3E?style=for-the-badge&logo=amazon&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-22C55E?style=for-the-badge)

A production-ready Terraform project that deploys a **fully private, secure EC2 environment** managed via AWS Systems Manager (SSM).  
Demonstrates advanced IaC principles including **modular design**, **remote state locking**, and **multi-environment workspace management**.

---

</div>

## 🏗️ Architecture Overview

The infrastructure follows a **Zero-Trust** approach — no public exposure, no SSH keys, no bastion hosts.

| Layer | Implementation | Purpose |
|:------|:---------------|:--------|
| **Network** | Private Subnet — No Public IP, No IGW | Complete network isolation |
| **Access** | AWS SSM via VPC Interface Endpoints | Secure, auditable shell access without SSH |
| **Storage** | S3 Gateway Endpoint | High-performance, private access to AWS S3 |
| **State** | S3 + DynamoDB Backend | Versioned, encrypted state with execution locking |

```
┌─────────────────────────────────────────────────────────────┐
│                        AWS Cloud                            │
│                                                             │
│   ┌───────────────── VPC (10.0.0.0/16) ───────────────┐    │
│   │                                                     │    │
│   │   ┌─────────────────────────────────┐               │    │
│   │   │       Private Subnet            │               │    │
│   │   │                                 │               │    │
│   │   │   ┌─────────────────────┐       │               │    │
│   │   │   │   EC2 Instance      │       │               │    │
│   │   │   │   (Amazon Linux 2023)│      │               │    │
│   │   │   │   No Public IP ✓    │       │               │    │
│   │   │   └────────┬────────────┘       │               │    │
│   │   │            │                    │               │    │
│   │   └────────────┼────────────────────┘               │    │
│   │                │                                     │    │
│   │   ┌────────────▼────────────────────────────────┐   │    │
│   │   │        VPC Endpoints (Interface + Gateway)   │   │    │
│   │   │  ┌──────────┐ ┌──────────┐ ┌──────────────┐ │   │    │
│   │   │  │ SSM      │ │ SSM Msg  │ │ S3 Gateway   │ │   │    │
│   │   │  │ Endpoint │ │ Endpoint │ │ Endpoint     │ │   │    │
│   │   │  └──────────┘ └──────────┘ └──────────────┘ │   │    │
│   │   └─────────────────────────────────────────────┘   │    │
│   └─────────────────────────────────────────────────────┘    │
│                                                             │
│   ┌──────────────────┐   ┌──────────────────┐               │
│   │  S3 State Bucket │   │  DynamoDB Lock   │               │
│   │  (Versioned/Enc) │   │  Table           │               │
│   └──────────────────┘   └──────────────────┘               │
└─────────────────────────────────────────────────────────────┘

         👤 Operator Access via SSM Fleet Manager
                  (No SSH · No Bastion)
```

---

## 🛠️ Professional Features

### Modular Design
Separated into **`network`** and **`compute`** modules for reusability and clean separation of concerns. Each module is self-contained with its own variables, outputs, and documentation.

### Remote State & Locking
State is stored in a **versioned, encrypted S3 bucket** with **DynamoDB** for execution locking — preventing state corruption during concurrent operations.

### Multi-Environment (Workspaces)
Uses **Terraform Workspaces** (`dev`, `prod`) with **Map lookups** to manage different environments from a single codebase. Environment-specific values (instance type, tags, sizing) are driven by workspace selection.

### Dynamic Data Sources
Automatically fetches the **latest Amazon Linux 2023 AMI** based on the deployment region, ensuring the environment is always running the most current image.

### Security Guardrails
Includes a custom **`terraform_data` precondition** to prevent accidental deployments to the `default` workspace — enforcing explicit environment selection.

---

## 📂 Project Structure

```
.
├── main.tf              # Root module: wiring modules + safety guards
├── variables.tf         # Environment-specific maps (Dev/Prod)
├── provider.tf          # AWS Provider & Remote Backend configuration
├── outputs.tf           # Stack outputs (instance ID, VPC ID, etc.)
├── terraform.tfvars     # (Optional) Value overrides
│
├── bootstrap/
│   └── bootstrap.tf     # S3 bucket + DynamoDB table for state backend
│
└── module/
    ├── network/         # VPC, Subnets, Security Groups, VPC Endpoints
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    │
    └── compute/         # EC2, IAM Roles, Instance Profiles
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

---

## 🚀 Getting Started

### Prerequisites

| Requirement | Details |
|:------------|:--------|
| **AWS CLI** | Configured with SSO or IAM credentials |
| **Terraform** | v1.5+ installed |
| **Backend** | S3 bucket + DynamoDB table created via `bootstrap.tf` |

### Step 1 — Bootstrap the Backend

> [!IMPORTANT]
> The bootstrap must be executed **first** to create the S3 state bucket and the DynamoDB lock table. These resources serve as the remote backend for Terraform state management.

```bash
cd bootstrap/
terraform init
terraform apply
```

### Step 2 — Initialize & Select Workspace

```bash
# Initialize and connect to the remote S3 backend
terraform init

# Create and switch to the development environment
terraform workspace new dev
terraform workspace select dev
```

### Step 3 — Deploy

```bash
# Preview the infrastructure changes
terraform plan

# Deploy the infrastructure
terraform apply
```

### Step 4 — Verify

1. Log in to the **AWS Console**
2. Navigate to **Systems Manager → Fleet Manager**
3. Verify the instance status is **Online**
4. Use **Node Actions → Start Terminal Session** to access the instance securely

---

## 🧹 Cleanup

> [!WARNING]
> To avoid ongoing costs — especially for **VPC Interface Endpoints** — destroy the environment when you are finished.

```bash
terraform workspace select dev
terraform destroy
```

---

## 👤 Author

**Built with ❤️ by Houssem Rezgui**

---

<div align="center">

*Zero-Trust · Private-by-Default · Infrastructure-as-Code*

</div>
]]>
