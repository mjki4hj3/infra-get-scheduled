# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "getscheduled-logs" {
  name = "getscheduled-logs"
}