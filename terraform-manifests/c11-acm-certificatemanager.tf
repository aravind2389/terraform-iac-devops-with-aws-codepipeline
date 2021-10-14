module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  #version = "~> 2.14.0"
  version = "3.0.0"

  domain_name  = trimsuffix(data.aws_route53_zone.my_route53.name, ".")
  zone_id      = data.aws_route53_zone.my_route53.zone_id

  subject_alternative_names = [
    #"*.aravindintellectual.click"
    var.dns_name
  ]

  tags = local.common_tags
}


output "this_acm_certificate_arn" {
  description = "The ARN of the certificate"
  #value = module.acm.this_acm_certificate_arn
  value = module.acm.acm_certificate_arn
}
