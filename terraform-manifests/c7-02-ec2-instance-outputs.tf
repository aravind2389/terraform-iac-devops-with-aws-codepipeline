# AWS EC2 Instance Terraform Outputs
# Public EC2 Instances - Bastion Host
output "ec2_bastion_public_instance_ids" {
  description = "list of IDs of instances"
  value = module.ec2_public.id
}

## ec2_bastion_public_ip
output "ec2_bastion_public_ip" {
  description = "List of public IP addresses assigned to the instances"
  value = module.ec2_public.public_ip
}

/*
# Private EC2 Instances
## ec2_private_instance_ids
output "ec2_private_instance_app1_ids" {
  description = "list of IDs of instances"
  value = module.ec2_private_app1.id
}

## ec2_bastion_public_ip
output "ec2_private_app1_ip" {
  description = "List of public IP addresses assigned to the instances"
  value = module.ec2_private_app1.private_ip
}


# Private EC2 Instances
## ec2_private_instance_ids
output "ec2_private_instance_app2_ids" {
  description = "list of IDs of instances"
  value = module.ec2_private_app2.id
}

## ec2_bastion_public_ip
output "ec2_private_app2_ip" {
  description = "List of public IP addresses assigned to the instances"
  value = module.ec2_private_app2.private_ip
}
*/