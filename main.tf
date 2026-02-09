terraform {
  backend "s3" {
    bucket         = "the-alpha-project-terraform-state"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-3" # Your region
    dynamodb_table = "the-alpha-project-state-locks"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "main" {
    bucket = "the-alpha-project-terraform-stateeee" # Your bucket name
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
    bucket = aws_s3_bucket.main.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_s3_bucket_versioning" "main" {
    bucket = aws_s3_bucket.main.id

    versioning_configuration {
        status = "Enabled"
    }
}

resource "terraform_data" "workspace_guard" {
    lifecycle {
      precondition {
        condition = terraform.workspace != "default"
        error_message = "❌ STOP! You are currently in the 'default' workspace. Please switch to 'dev' or 'prod' using 'terraform workspace select <env>' before running apply."

      }

    }
  
}

data "aws_ami" "latest_amazon_linux" {
    most_recent = true
    owners = [ "amazon" ]

    filter {
      name = "name"
      values = ["al2023-ami-2023*-kernel-6.1-x86_64"]

    }
    filter {
      name = "virtualization-type"
      values = ["hvm"]
    }
}

locals {
  env = var.env_config[terraform.workspace]
}


module "network" {
    source = "./module/network"
    project_name = local.env.project_name
    region = local.env.region
    vpc_cidr = local.env.vpc_cidr
    private_subnet_cidr =   local.env.private_subnet_cidr
    availability_zones = local.env.availability_zones
}



module "compute" {
    source = "./module/compute"
    vpc_id = module.network.vpc_id
    vpc_cidr = module.network.vpc_cidr
    project_name = local.env.project_name
    ami_id = data.aws_ami.latest_amazon_linux.id
    private_subnet_id = module.network.private_subnet_id
    ec2_sg_id = module.network.ec2_sg_id
    
  
}


resource "aws_cloudwatch_dashboard" "main" {
    dashboard_name = "${local.env.project_name}-dashboard"

    dashboard_body = jsonencode({
        widgets = [
            {
                type = "metric"
                x = 0
                y = 0
                width = 12
                height = 6
                properties = {
                    metrics = [
                        [ "AWS/EC2", "CPUUtilization", "InstanceId", module.compute.instance_id ]
                    ]
                    period = 300
                    stat = "Average"
                    region = local.env.region
                    title = "EC2 CPU Utilization"
                }
            },
                {
                type = "metric"
                x = 12
                y = 0
                width = 12
                height = 6
                properties = {
                    metrics = [
                        [ "AWS/EC2", "StatusCheckFailed", "InstanceId", module.compute.instance_id ]
                    ]
                    period = 300
                    stat = "Average"
                    region = local.env.region
                    title = "hardware/instance health"
                    }
                }
        ]
    })
  
}