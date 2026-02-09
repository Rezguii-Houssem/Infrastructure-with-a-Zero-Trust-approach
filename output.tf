output "instance_id" {
    value = module.compute.instance_id
    description = "The instance id output"
  
}

output "ec2_sg_id" {
    value = module.network.ec2_sg_id
    description = "The security group id output"
  
}

output "private_subnet_id" {
    value = module.network.private_subnet_id
    description = "The private subnet id output"
  
}