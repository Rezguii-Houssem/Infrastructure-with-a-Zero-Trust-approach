output "private_subnet_id" {
    description = "The id of the private subnet"
    value = var.private_subnet_id
}


output "ec2_sg_id" {
    description = "The id of the security group for the instance"
    value = var.ec2_sg_id
  
}

# modules/compute/outputs.tf
output "instance_id" {
  description = "ID of the created EC2 instance"
  value       = aws_instance.ec2.id  # Use your actual resource name
}