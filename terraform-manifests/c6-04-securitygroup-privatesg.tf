module "private_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  #version = "3.18.0"
  version  =  "4.0.0"
  # insert the 3 required variables here
  name        = "${local.name}-private_sg"
  description = "Security group for Bastion_Host in PublicSubnet"
  vpc_id      = module.vpc.vpc_id
#Ingress_rules & CIDR blocks 
  ingress_cidr_blocks      = [module.vpc.vpc_cidr_block]
  ingress_rules            = ["ssh-tcp","http-80-tcp","http-8080-tcp"]
#Egress_rules all-all open
  egress_rules             = ["all-all"]
  tags = local.common_tags
}