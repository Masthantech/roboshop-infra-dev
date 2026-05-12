module vpc {
    #source = "../terraform-aws-vpc"
    source = "git::https://github.com/Masthantech/terraform-aws-vpc.git?ref=main"
    project = var.project
    environment = var.environment
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    #is_peering_required = false
}

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "public_subnet_ids" {
    value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
    value = module.vpc.private_subnet_ids
}

output "database_subnet_ids" {
    value = module.vpc.database_subnet_ids
}