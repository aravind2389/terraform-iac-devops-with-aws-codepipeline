#Security group for Bastion_Host in Public Subnet
module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  #version = "3.18.0"
  version = "4.0.0"
  # insert the 3 required variables here
  name        = "${local.name}-public_bastion_sg"
  description = "Security group for Bastion_Host in PublicSubnet"
  vpc_id      = module.vpc.vpc_id
#Ingress_rules & CIDR blocks 
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["ssh-tcp"]
#Egress_rules all-all open
  egress_rules             = ["all-all"]
  tags = local.common_tags
}