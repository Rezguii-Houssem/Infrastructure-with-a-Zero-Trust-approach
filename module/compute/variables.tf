variable "vpc_id" {
    description = "The ID of the VPC where the compute resources will be deployed."
    type        = string
  
}

variable "vpc_cidr" {
    description = "The cidr block of the vpc"
    type = string
  
}

variable "private_subnet_id" {
    description = "The ID of the private subnet where the compute resources will be deployed."
    type = string
}

variable "ami_id" {
    description = "The ami of the instance"
    type = string
  
}

variable "project_name" {
    description = "The name of the project"
    type = string
}

variable "ec2_sg_id" {
    description = "The ID of the EC2 security group"
    type = string
}

