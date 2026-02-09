resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = {
        Name = "${var.project_name}-vpc"
    }
}


resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = var.availability_zones[count.index]
    tags = {
        Name = "${var.project_name}-private-subnet-${count.index + 1}"
    }

}

resource "aws_security_group"  "ssm-sg" {
    name = "${var.project_name}-ssm-sg"
    description = "security group for ssm"
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "${var.project_name}-ssm-sg"
    }
}
resource "aws_security_group" "ec2_sg" {
    name = "${var.project_name}-ec2-sg"
    description = " The sg of the instance"
    vpc_id = aws_vpc.main.id
    
  
}

resource "aws_vpc_security_group_egress_rule" "egress" {
    ip_protocol = "tcp"
    from_port = 443
    to_port = 443
    security_group_id = aws_security_group.ec2_sg.id
    referenced_security_group_id = aws_security_group.ssm-sg.id
    
    
  
}
resource "aws_vpc_security_group_ingress_rule" "ssm-ingress" {
    ip_protocol = "tcp"
    from_port = 443
    to_port = 443
    security_group_id = aws_security_group.ssm-sg.id
    referenced_security_group_id = aws_security_group.ec2_sg.id
 
  
}


resource "aws_route_table" "main" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "${var.project_name}-route-table"
    } 
}

resource "aws_route_table_association" "main" {
    count = length(aws_subnet.private)
    subnet_id = aws_subnet.private[count.index].id
    route_table_id = aws_route_table.main.id
  
}

resource "aws_vpc_endpoint" "ssm_endpoints" {
    for_each = toset(["ssm", "ssmmessages", "ec2messages"])
    vpc_id = aws_vpc.main.id
    service_name = "com.amazonaws.${var.region}.${each.value}"
    vpc_endpoint_type = "Interface"

    private_dns_enabled = true
    security_group_ids = [aws_security_group.ssm-sg.id]
    subnet_ids = aws_subnet.private[*].id
    tags = {
        Name = "${var.project_name}-${each.value}-endpoint"
    }
}


