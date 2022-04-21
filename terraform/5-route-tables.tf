
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
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public-subnet-one-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-one.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Associate Public Subnet Two to "Public Route Table"
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "public-subnet-two-route-table-association" {
  subnet_id           = aws_subnet.public-subnet-two.id
  route_table_id      = aws_route_table.public-route-table.id
}

# Create Private Route Table One
# terraform aws create route table
resource "aws_route_table" "private-route-table-one" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_nat_gateway.natgateway-one.id
  }

  depends_on = [
    aws_nat_gateway.natgateway-one
  ]

  tags       = {
    Name     = "Private Route Table One"
  }
}

# Create Private Route Table Two
# terraform aws create route table
resource "aws_route_table" "private-route-table-two" {
  vpc_id       = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id =  aws_nat_gateway.natgateway-two.id
  }

  depends_on = [
    aws_nat_gateway.natgateway-two
  ]

  tags       = {
    Name     = "Private Route Table Two"
  }
}


# Associate Private Subnet One to "Private Route Table"
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "private-subnet-one-route-table-association" {
  subnet_id           = aws_subnet.private-subnet-one.id
  route_table_id      = aws_route_table.private-route-table-one.id
}

# Associate Private Subnet Two to "Private Route Table"
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "private-subnet-two-route-table-association" {
  subnet_id           = aws_subnet.private-subnet-two.id
  route_table_id      = aws_route_table.private-route-table-two.id
}