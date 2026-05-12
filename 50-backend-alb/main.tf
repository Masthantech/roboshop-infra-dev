module "backend_alb" {
  source = "terraform-aws-modules/alb/aws"
  internal = true
  name    = local.alb_name #roboshop-dev-backend-alb
  vpc_id  = local.vpc_id
  subnets = local.private_subnet_ids
  create_security_group = false
  security_groups = [local.backend_alb_sg_id]
  enable_deletion_protection = false


  tags = merge(
    local.common_tags,
    {
        Name = "${var.project}-${var.environment}-backend-alb"
    }
  )

  # Security Group
  
}

resource "aws_route53_record" "backend-alb" {
  zone_id = var.zone_id
  name    = "*.backend-dev.${var.name}"
  type    = "A"

  alias {
    name                   = module.backend_alb.dns_name
    zone_id                = module.backend_alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_lb_listener" "backend_alb" {
  load_balancer_arn = module.backend_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from backend alb<h1>"
      status_code  = "200"
    }
  }
}