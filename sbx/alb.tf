/*

resource "aws_security_group" "security_group_alb" {
  name = "ec2-machine-sg"

  vpc_id = aws_vpc.vpc_tech_cloud_worshop_g["vpc_3"].id

  
  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

   ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["172.31.0.0/16"]
  }
}

module "alb" {
  source = "cloudposse/alb/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version = "x.x.x"

  namespace  = "cloud_technalia"
  stage      = var.stage
  name       = "alb-tech"
  vpc_id                                  = aws_vpc.vpc_tech_cloud_worshop_g["vpc_3"].id
  security_group_ids                      = [aws_security_group.security_group_alb.id]
  subnet_ids                              = [aws_subnet.subnets_asociated_wg["cidr_public_a_vpc_3"].id, aws_subnet.subnets_asociated_wg["cidr_public_b_vpc_3"].id]
  internal                                = false
  http_enabled                            = true
  http_redirect                           = false
  access_logs_enabled                     = false
  cross_zone_load_balancing_enabled       = true
  http2_enabled                           = true
  idle_timeout                            = 60
  ip_address_type                         = "ipv4"
  deregistration_delay                    = 15
  health_check_path                       = "/"
  health_check_timeout                    = 10
  health_check_healthy_threshold          = 2
  health_check_unhealthy_threshold        = 2
  health_check_interval                   = 15
  health_check_matcher                    = "200-399"
  health_check_port                       = "traffic-port"
  target_group_port                       = 80
  target_group_target_type                = "instance"
  
 
  tags = {
    Name = "${local.account_id}-alb-tech"
    Cost = "techCloud"
  }

}

resource "aws_lb_target_group_attachment" "tg_attacheck_1" {
  target_group_arn = module.alb.default_target_group_arn
  target_id        = aws_instance.ec2_sbx.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attacheck_2" {
  target_group_arn = module.alb.default_target_group_arn
  target_id        = aws_instance.ec2_sbx_machine_2.id
  port             = 80
}

resource "aws_lb_target_group" "tg_instances_two" {
  name     = "tgWebserverTwo"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_tech_cloud_worshop_g["vpc_3"].id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 15
  }
}


resource "aws_lb_target_group_attachment" "tg_attacheck_3" {
  target_group_arn = aws_lb_target_group.tg_instances_two.arn
  target_id        = aws_instance.ec2_sbx_machine_3.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attacheck_4" {
  target_group_arn = aws_lb_target_group.tg_instances_two.arn
  target_id        = aws_instance.ec2_sbx_machine_4.id
  port             = 80
}
*/