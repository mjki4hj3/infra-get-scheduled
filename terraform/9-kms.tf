#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key

resource "aws_kms_key" "getscheduled-kms-key" {
  description             = "key for getscheduled"
  deletion_window_in_days = 7
}