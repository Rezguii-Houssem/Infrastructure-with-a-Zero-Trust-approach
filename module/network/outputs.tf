output "vpc_id" {
    description = "The Id of the vpc"
    value = aws_vpc.main.id
  
}

output "private_subnet_id" {
    description = "The ids of the private subnets"
    value = aws_subnet.private[0].id
}



output "security_group_ids" {
    description = "The ids of the security groups"
    value = [aws_security_group.ssm-sg.id, aws_security_group.ec2_sg.id]
  
}

output "vpc_cidr" {
    description = "The cidr block of the vpc"
    value = aws_vpc.main.cidr_block
  
}

output "ec2_sg_id" {
    description = "The id of the security group for the EC2 instance"
    value = aws_security_group.ec2_sg.id
  
}