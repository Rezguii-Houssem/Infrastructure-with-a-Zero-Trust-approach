resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = "t2.micro"
    subnet_id = var.private_subnet_id
    iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
    security_groups = [var.ec2_sg_id]
        tags = {
            Name = "${var.project_name}-ec2-instance"
        }
  
}