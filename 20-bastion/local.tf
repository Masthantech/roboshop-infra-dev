locals {
    ami_id = data.aws_ami.joindevops.id
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = true
    }
    subnet_id = split(",", data.aws_ssm_parameter.subnet_id.value)[0]
    sg_id = data.aws_ssm_parameter.sg_id.value
}

