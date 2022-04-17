#Create Security Group for Fargate
#terraform aws create security group

resource "aws_security_group" "FargateContainerSecurityGroup" {
  name        = "FargateContainerSecurityGroup"
  description = "Allow TLS inbound traffic to Fargate Containers"
  vpc_id      = aws_vpc.vpc.id 

  ingress {
    description      = "TLS from VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["${var.vpc-cidr}"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Fargate Container Security Group"
  }
}