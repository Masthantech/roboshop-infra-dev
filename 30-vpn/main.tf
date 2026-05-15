resource "aws_instance" "vpn" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [local.sg_id]
    subnet_id = local.public_subnet_id
    key_name = "vpn"
    user_data = file("openvpn.sh")

    tags = merge(
        local.common_tags,
        var.vpn_tags,
        {
            Name = "${var.project}-${var.environment}-openvpn"
        }
        
    )
}

resource "aws_route53_record" "vpn-dev" {
  zone_id = var.zone_id
  name    = "vpn-${var.environment}.${var.zone_name}"
  type    = "A"
  ttl     = 1
  records = [aws_instance.vpn.public_ip]
  allow_overwrite = true
}




