variable "vpc_name" {
  description = "Name of the VPC"
  type = string
  default = "myvpc"
}

variable "vpc_cidr" {
  description = "VPC cidr block"
  type = string
  default = "10.0.0.0/16"
}

variable "vpc_availability_zones" {
  description = "VPC azs"
  type = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "vpc_private_subnets" {
  description = "VPC private subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "VPC public subnets"
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_database_subnets" {
  description = "VPC database subnets"
  type = list(string)
  default = ["10.0.151.0/24", "10.0.152.0/24"]
}

variable "vpc_create_database_subnet_group" {
  description = "create_database_subnet_group"
  type = bool
  default = "true"
}

variable "vpc_create_database_subnet_route_table" {
  description = "create_database_subnet_route_table"
  type = bool
  default = "true"
}

variable "enable_nat_gateway" {
  description = "to enable the nat gateway for private subnet"
  type = bool
  default = true
}

variable "single_nat_gateway" {
  description = "to enable only one nat gateway for both private subnets "
  type = bool
  default = true
}
