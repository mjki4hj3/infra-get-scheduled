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
















