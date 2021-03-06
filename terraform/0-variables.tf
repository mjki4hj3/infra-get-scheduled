variable "account_id" {
    description = "The AWS account id"  
}

variable "region" {
    default = "us-east-1"
    description = "region to deploy the resources in"
}

variable "vpc-cidr" {

    default = "10.0.0.0/16"
    description = "VPC CIDR Block"
    type = string

}

variable "public-subnet-one-cidr" {

    default = "10.0.0.0/24"
    description = "Public Subnet One CIDR Block"
    type = string

}

variable "public-subnet-two-cidr" {

    default = "10.0.1.0/24"
    description = "Public Subnet Two CIDR Block"
    type = string

}

variable "private-subnet-one-cidr" {

    default = "10.0.2.0/24"
    description = "Private Subnet One CIDR Block"
    type = string

}

variable "private-subnet-two-cidr" {

    default = "10.0.3.0/24"
    description = "Private Subnet Two CIDR Block"
    type = string

}
