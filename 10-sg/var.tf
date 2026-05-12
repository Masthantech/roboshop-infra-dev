variable "project" {
    default = "roboshop"
}

variable "environment" {
    default = "dev"
}


variable "sg_name" {
    default = "frontend"
}

variable "frontend_sg_description" {
    default = "created sg form fronted instance"
}

variable "sg_tags" {
    default = {}
}

variable "bastion_sg_name" {
    default = "bastion"
}

variable "bastion_sg_description" {
    default = "created sg for bastion instance"
}


variable "alb_sg_name" {
    default = "backend-alb"
}

variable "alb_sg_description" {
    default = "created sg for backend-alb instance"
}

variable "vpn_sg_name" {
    default = "roboshop-vpn"
}

variable "vpn_sg_description" {
    default = "created sg for roboshop-vpn instance"
}

variable "mongodb_sg_name" {
    default = "mongodb"
}

variable "mongodb_sg_description" {
    default = "created sg for mongodb instance"
}

variable "mongodb_ports" {
    default = [22, 27017]
}

variable "redis_ports" {
    default = [22, 6379]
} 

variable "mysql_ports" {
    default = [22, 3306]
} 
                                                                 
 variable "rabbitmq_ports" {
    default = [22, 5672]
}

variable "catalogue_ports" {
    default = [22, 8080]
}
