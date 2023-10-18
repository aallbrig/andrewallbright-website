locals {
  cidr_parts   = split(".", split("/", data.aws_vpc.default_vpc.cidr_block)[0])
  default_vpc_first_two_cidr_octets = format("%s.%s", local.cidr_parts[0], local.cidr_parts[1])
  web_tier_subnet_cidr = format("%s.127.0/28", local.default_vpc_first_two_cidr_octets)
  application_tier_subnet_cidr = format("%s.127.16/28", local.default_vpc_first_two_cidr_octets)
  data_tier_subnet_cidr = format("%s.127.32/28", local.default_vpc_first_two_cidr_octets)
}