#Get DNS information from AWS Route53
data "aws_route53_zone" "my_route53" {
  name         = "aravindintellectual.click"
}

#output MyDomain Zone_id
output "mydomain_zoneid" {
  description = "The Hosted Zone id of the desired Hosted Zone"
  value = data.aws_route53_zone.my_route53.zone_id
}

output "mydomain_name" {
  description = " The Hosted Zone name of the desired Hosted Zone."
  value = data.aws_route53_zone.my_route53.name
}
