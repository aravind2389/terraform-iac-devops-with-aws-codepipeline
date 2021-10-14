variable "instance_type" {
  description = "the type of instance to be created"
  type = string
  default = "t3.micro"
}

variable "instance_keypair" {
  description = "keypair for bastion host"
  type = string
  default = "terraform_key"
}

variable "private_instance_count" {
  description = "number of private instances"
  type = number
  default = 1 
}