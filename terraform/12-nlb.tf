# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

resource "aws_lb" "getscheduled_nlb" {
  name               = "getscheduled-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["${aws_subnet.public-subnet-one.id}", "${aws_subnet.public-subnet-two.id}"]

  enable_deletion_protection = true

  tags = {
    Environment = "production"
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/lb_target_group

resource "aws_lb_target_group" "getscheduled_target_group" {
    name = "GetScheduled-TargetGroup"
    port =  8080
    protocol = "TCP"
    vpc_id = aws_vpc.vpc.id
    target_type = "ip"
    health_check {
      interval = 10
      path = "/"
      protocol = "HTTP"
      healthy_threshold = 3
      unhealthy_threshold = 3
    }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener

resource "aws_lb_listener" "getscheduled_listener" {
    load_balancer_arn = aws_lb.getscheduled_nlb.arn
    port = 8080
    protocol = "TCP"
    default_action {
        target_group_arn = aws_lb_target_group.getscheduled_target_group.arn
        type = "forward"
    }
}
  
