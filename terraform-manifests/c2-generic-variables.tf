variable "aws_region" {
  description = "Region in which aws resources need to be created"
  type = string
  default = "us-east-1"
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type = string
  default = "dev"
}

variable "business_division" {
  description = "Business Division in the large organization "
  type = string
  default = "SAP"
}