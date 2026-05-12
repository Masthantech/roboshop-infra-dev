locals {
    
    ami_id = data.aws_ami.openvpn.id
    public_subnet_id = split("," , data.aws_ssm_parameter.subnet_id.value)[0]
    sg_id = data.aws_ssm_parameter.vpn_sg_id.value
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = true
    }
}