resource "aws_cloudformation_stack" "wordpress_networking" {
  name = format("%s-%s", var.project_namespace, "wordpress-networking")

  template_body = file("${path.module}/../cloudformation/wordpress_networking.yaml")

  parameters = {
    VpcId = data.aws_vpc.default_vpc.id
    WebTierCidrBlock = local.web_tier_subnet_cidr
    ApplicationTierCidrBlock = local.application_tier_subnet_cidr
    DataTierCidrBlock = local.data_tier_subnet_cidr
  }
}

resource "aws_cloudformation_stack" "wordpress_lightsail" {
  name = format("%s-%s", var.project_namespace, "wordpress-lightsail")

  template_body = file("${path.module}/../cloudformation/wordpress_lightsail.yaml")
}

resource "aws_cloudformation_stack" "wordpress_hostedzone_apex" {
  name = format("%s-%s", var.project_namespace, "wordpress-hostedzone")

  template_body = file("${path.module}/../cloudformation/wordpress_hostedzone.yaml")

  parameters = {
    IPAddress: aws_cloudformation_stack.wordpress_lightsail.outputs.LightsailInstancePublicIpAddress
    HostedZoneId: data.aws_route53_zone.website_hosted_zone.zone_id
    RecordName: var.hosted_zone_name
  }
}
