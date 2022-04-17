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
