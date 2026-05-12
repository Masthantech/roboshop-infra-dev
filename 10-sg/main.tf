module "frontend" {
    source = "git::https://github.com/Masthantech/terraform-aws-securitygroup.git?ref=main"
    sg_name = var.sg_name
    sg_description = var.frontend_sg_description
    project = var.project
    environment = var.environment
    vpc_id = local.vpc_id

} 

module "bastion" {
    source = "git::https://github.com/Masthantech/terraform-aws-securitygroup.git?ref=main"
    sg_name = var.bastion_sg_name
    sg_description = var.bastion_sg_description
    project = var.project
    environment = var.environment
    vpc_id = local.vpc_id

} 

module "backend_alb" {
    source = "git::https://github.com/Masthantech/terraform-aws-securitygroup.git?ref=main"
    sg_name = var.alb_sg_name
    sg_description = var.alb_sg_description
    project = var.project
    environment = var.environment
    vpc_id = local.vpc_id

} 

module "roboshop_vpn" {
    source = "git::https://github.com/Masthantech/terraform-aws-securitygroup.git?ref=main"
    sg_name = var.vpn_sg_name
    sg_description = var.vpn_sg_description
    project = var.project
    environment = var.environment
    vpc_id = local.vpc_id

} 

module "mongodb" {
    source = "git::https://github.com/Masthantech/terraform-aws-securitygroup.git?ref=main"
    sg_name = var.mongodb_sg_name
    sg_description = var.mongodb_sg_description
    project = var.project
    environment = var.environment
    vpc_id = local.vpc_id

} 

module "redis" {
  source = "git::https://github.com/Masthantech/terraform-aws-securitygroup.git?ref=main"
  sg_name = "redis"
  sg_description = "for redis"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "mysql" {
  source = "git::https://github.com/Masthantech/terraform-aws-securitygroup.git?ref=main"
  sg_name = "mysql"
  sg_description = "for mysql"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "rabbitmq" {
  source = "git::https://github.com/Masthantech/terraform-aws-securitygroup.git?ref=main"
  sg_name = "rabbitmq"
  sg_description = "for rabbitmq"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

module "catalogue" {
  source = "git::https://github.com/Masthantech/terraform-aws-securitygroup.git?ref=main"
  sg_name = "catalogue"
  sg_description = "for catalogue"
  project = var.project
  environment = var.environment
  vpc_id = local.vpc_id
}

#catalogue accepting connections from vpn
resource "aws_security_group_rule" "catalogue_to_vpn" {
  count = length(var.catalogue_ports)
  type              = "ingress"
  from_port         = var.catalogue_ports[count.index]
  to_port           = var.catalogue_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.roboshop_vpn.sg_id
  security_group_id = module.catalogue.sg_id
}

#catalogue accepting connections from backend alb
resource "aws_security_group_rule" "catalogue_to_backend_alb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  source_security_group_id = module.backend_alb.sg_id
  security_group_id = module.catalogue.sg_id
}


#catalogue accepting connections from bastion
resource "aws_security_group_rule" "catalogue_to_bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.catalogue.sg_id
}

#mongodb accepting connections from catalogue
resource "aws_security_group_rule" "mongodb_to_catalogue" {
  type              = "ingress"
  from_port         = 27017
  to_port           = 27017
  protocol          = "tcp"
  source_security_group_id = module.catalogue.sg_id
  security_group_id = module.mongodb.sg_id
}

#mongodb accepting connections from vpn
resource "aws_security_group_rule" "mongodb_to_vpn" {
  count = length(var.mongodb_ports)
  type              = "ingress"
  from_port         = var.mongodb_ports[count.index]
  to_port           = var.mongodb_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.roboshop_vpn.sg_id
  security_group_id = module.mongodb.sg_id
}

#redis accepting connections from vpn
resource "aws_security_group_rule" "redis_to_vpn" {
  count = length(var.redis_ports)
  type              = "ingress"
  from_port         = var.redis_ports[count.index]
  to_port           = var.redis_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.roboshop_vpn.sg_id
  security_group_id = module.redis.sg_id
}

#mysql accepting connections from vpn
resource "aws_security_group_rule" "mysql_to_vpn" {
  count = length(var.mysql_ports)
  type              = "ingress"
  from_port         = var.mysql_ports[count.index]
  to_port           = var.mysql_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.roboshop_vpn.sg_id
  security_group_id = module.mysql.sg_id
}

#rabbitmq accepting connections from vpn
resource "aws_security_group_rule" "rabbitmq_to_vpn" {
  count = length(var.rabbitmq_ports)
  type              = "ingress"
  from_port         = var.rabbitmq_ports[count.index]
  to_port           = var.rabbitmq_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.roboshop_vpn.sg_id
  security_group_id = module.rabbitmq.sg_id
}

#bastion accepting connections from my laptop
resource "aws_security_group_rule" "bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}

# database accepting connections from bastion host on port 80
resource "aws_security_group_rule" "mongodb_to_bastion" {
  count = length(var.mongodb_ports)
  type              = "ingress"
  from_port         = var.mongodb_ports[count.index]
  to_port           = var.mongodb_ports[count.index]
  protocol          = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.mongodb.sg_id
}

# backend-alb accepting connections from bastion host on port 80
resource "aws_security_group_rule" "backend_alb_bastion" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
 # cidr_blocks       = module.backend_alb.sg_id
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend_alb.sg_id
}

# roboshop vpn accepting connections from my laptop
resource "aws_security_group_rule" "vpn_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.roboshop_vpn.sg_id
}

resource "aws_security_group_rule" "vpn_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.roboshop_vpn.sg_id
}

resource "aws_security_group_rule" "vpn_1194" {
  type              = "ingress"
  from_port         = 1194
  to_port           = 1194
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.roboshop_vpn.sg_id
}

resource "aws_security_group_rule" "vpn_943" {
  type              = "ingress"
  from_port         = 943
  to_port           = 943
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.roboshop_vpn.sg_id
}

resource "aws_security_group_rule" "vpn_to_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  source_security_group_id = module.roboshop_vpn.sg_id
  security_group_id = module.backend_alb.sg_id
}

output "sg_id" {
    value = module.frontend.sg_id
}

