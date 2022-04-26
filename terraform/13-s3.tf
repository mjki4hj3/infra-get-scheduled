# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket

resource "aws_s3_bucket" "getscheduled-artifacts-bucket" {
  bucket = "getscheduled-artifacts-bucket"
}