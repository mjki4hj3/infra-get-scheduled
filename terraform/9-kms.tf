resource "aws_kms_key" "getscheduled-kms-key" {
  description             = "key for getscheduled"
  deletion_window_in_days = 7
}