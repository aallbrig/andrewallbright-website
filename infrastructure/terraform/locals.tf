locals {
  cidr_parts   = split(".", split("/", data.aws_vpc.default_vpc.cidr_block)[0])
  default_vpc_first_two_cidr_octets = format("%s.%s", local.cidr_parts[0], local.cidr_parts[1])
  public_wordpress_subnet_cidr = format("%s.124.0/28", local.default_vpc_first_two_cidr_octets)
}