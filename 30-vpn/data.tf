data "aws_ami" "openvpn" {
  owners = ["679593333241"]
  most_recent = true

  filter{
    name = "name"
    values = ["OpenVPN Access Server Community Image-3b5882c4-*"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

}


data "aws_ssm_parameter" "subnet_id" {
  name = "/${var.project}/${var.environment}/public_subnet_ids"
}


data "aws_ssm_parameter" "vpn_sg_id" {
  name  = "/${var.project}/${var.environment}/roboshop_vpn_sg_id"
}
