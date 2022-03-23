terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


# Create VPC
# terraform aws create vpc
resource "aws_vpc" "vpc" {
  cidr_block              = "${var.vpc-cidr}"
  instance_tenancy        =  "default"
  enable_dns_hostnames    =  true
  enable_dns_support      =  true

  tags      = {
    Name    = "getscheduled-vpc"
  }
}

# Create Internet Gateway and Attach it to VPC
# terraform aws create internet gateway
resource "aws_internet_gateway" "internet-gateway" {
  vpc_id    = aws_vpc.vpc.id 

  tags      = {
    Name    = "getscheduled-igw"
  }
}

# Create Public Subnet 1
# terraform aws create subnet
resource "aws_subnet" "public-subnet-one" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              =  "${var.public-subnet-one-cidr}"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "getscheduled-public-subnet-one"
  }
}

# Create Public Subnet 2
# terraform aws create subnet
resource "aws_subnet" "public-subnet-two" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              =  "${var.public-subnet-two-cidr}"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags      = {
    Name    = "getscheduled-public-subnet-two"
  }
}

# Create Route Table and Add Public Route
# terraform aws create route table
resource "aws_route_table" "public-route-table" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_internet_gateway.internet-gateway.id
  }

  tags       = {
    Name     = "Public Route Table"
  }
}

# Associate Public Subnet One to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-one-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-one.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associate Public Subnet Two to "Public Route Table"
# terraform aws associate subnet with route table
resource "aws_route_table_association" "public-subnet-two-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-two.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Create Private Subnet One
# terraform aws create subnet
resource "aws_subnet" "private-subnet-one" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-one-cidr}"
  availability_zone        = "us-east-1a"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "getscheduled-private-subnet-one"
  }
}

# Create Private Subnet Two
# terraform aws create subnet
resource "aws_subnet" "private-subnet-two" {
  vpc_id                   = aws_vpc.vpc.id
  cidr_block               = "${var.private-subnet-two-cidr}"
  availability_zone        = "us-east-1b"
  map_public_ip_on_launch  = false

  tags      = {
    Name    = "getscheduled-private-subnet-two"
  }
}

# Allocate Elastic IP Address (EIP One)
# terraform aws allocate elastic ip
resource "aws_eip" "eip-for-nat-gateway-one" {
  vpc    = true

  tags   = {
    Name = "getscheduled-eip-one"
  }
}

# Allocate Elastic IP Address (EIP Two)
# terraform aws allocate elastic ip
resource "aws_eip" "eip-for-nat-gateway-two" {
  vpc    = true

  tags   = {
    Name = "getscheduled-eip-two"
  }
}

#Create NatGateWay One
# terraform aws create natgateway

resource "aws_nat_gateway" "natgateway-one" {
  allocation_id = aws_eip.eip-for-nat-gateway-one.id
  subnet_id     = aws_subnet.private-subnet-one.id

  tags = {
    Name = "getscheduled-ngw-one"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gateway]
}


#Create NatGateWay Two
# terraform aws create natgateway
resource "aws_nat_gateway" "natgateway-two" {
  allocation_id = aws_eip.eip-for-nat-gateway-two.id
  subnet_id     = aws_subnet.private-subnet-two.id

  tags = {
    Name = "getscheduled-ngw-two"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gateway]
}


# Create Private Route Table One
# terraform aws create route table
resource "aws_route_table" "private-route-table-one" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_nat_gateway.natgateway-one.id
  }

  tags       = {
    Name     = "Private Route Table One"
  }
}

# Create Private Route Table Two
# terraform aws create route table
resource "aws_route_table" "private-route-table-tow" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_nat_gateway.natgateway-two.id
  }

  tags       = {
    Name     = "Private Route Table Two"
  }
}

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