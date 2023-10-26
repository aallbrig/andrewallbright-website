locals {
  http_hostname = format("http://%s", var.hosted_zone_name)
  https_hostname = format("https://%s", var.hosted_zone_name)
  cidr_parts   = split(".", split("/", data.aws_vpc.default_vpc.cidr_block)[0])
  default_vpc_first_two_cidr_octets = format("%s.%s", local.cidr_parts[0], local.cidr_parts[1])
  web_tier_subnet_a_cidr = format("%s.126.0/27", local.default_vpc_first_two_cidr_octets)
  web_tier_subnet_b_cidr = format("%s.126.32/27", local.default_vpc_first_two_cidr_octets)
  application_tier_subnet_cidr = format("%s.126.64/28", local.default_vpc_first_two_cidr_octets)
  data_tier_subnet_cidr = format("%s.126.80/28", local.default_vpc_first_two_cidr_octets)
  # Amazon Linux 2023
  wordpress_ec2_ami_map = {
    "us-east-2"      = "ami-09d9029d9fc5e5238"
  }
  wordpress_ec2_ami = lookup(local.wordpress_ec2_ami_map, var.aws_region, "")
  az_map = {
    "us-east-2a"      = "use2-az1"
    "us-east-2b"      = "use2-az2"
    "us-east-2c"      = "use2-az3"
  }
  az_a = lookup(local.az_map, data.aws_availability_zones.available.names[0], "")
  az_b = lookup(local.az_map, data.aws_availability_zones.available.names[1], "")
  az_c = lookup(local.az_map, data.aws_availability_zones.available.names[2], "")
}