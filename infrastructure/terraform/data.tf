data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_route53_zone" "website_hosted_zone" {
  name = format("%s.", var.hosted_zone_name)
}