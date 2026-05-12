resource "aws_instance" "bastion" {
  ami           = local.ami_id
  instance_type = "t3.micro"
  subnet_id = local.subnet_id
  vpc_security_group_ids = [local.sg_id]

  tags = merge(
    local.common_tags,
    var.ec2_tags,
    {
        Name = "${var.project}-${var.environment}-bastion"
    }
  )
}