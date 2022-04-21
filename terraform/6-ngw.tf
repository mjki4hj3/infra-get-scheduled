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
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway

resource "aws_nat_gateway" "natgateway-one" {
  allocation_id = aws_eip.eip-for-nat-gateway-one.id
  subnet_id     = aws_subnet.public-subnet-one.id

  tags = {
    Name = "getscheduled-ngw-one"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gateway]
}


#Create NatGateWay Two
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
resource "aws_nat_gateway" "natgateway-two" {
  allocation_id = aws_eip.eip-for-nat-gateway-two.id
  subnet_id     = aws_subnet.public-subnet-two.id

  tags = {
    Name = "getscheduled-ngw-two"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.internet-gateway]
}