terraform {
  required_version = ">= 1.5.0"       # Terraform version
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"           # AWS provider version
    }
  }
}

provider "aws" {
  region = var.env_config[terraform.workspace].region
}
