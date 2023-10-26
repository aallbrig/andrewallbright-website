data "aws_vpc" "default_vpc" {
  default = true
}
data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_availability_zone" "az_a" {
  name = data.aws_availability_zones.available.names[0]
}
data "aws_route53_zone" "website_hosted_zone" {
  name = format("%s.", var.hosted_zone_name)
}
data "aws_subnet" "web_tier_subnet_a" {
  id = aws_cloudformation_stack.wordpress_networking.outputs.WebTierSubnetAId
}
data "aws_subnet" "web_tier_subnet_b" {
  id = aws_cloudformation_stack.wordpress_networking.outputs.WebTierSubnetBId
}
data "aws_subnet" "application_tier_subnet" {
  id = aws_cloudformation_stack.wordpress_networking.outputs.ApplicationTierSubnetId
}
data "aws_subnet" "data_tier_subnet" {
  id = aws_cloudformation_stack.wordpress_networking.outputs.DataTierSubnetId
}
data "aws_security_group" "admin_sg" {
  id = aws_cloudformation_stack.wordpress_networking.outputs.AdministrativeAccessSecurityGroup
}
data "aws_security_group" "web_tier_sg" {
  id = aws_cloudformation_stack.wordpress_networking.outputs.WebTierSecurityGroupId
}
data "aws_security_group" "application_tier_sg" {
  id = aws_cloudformation_stack.wordpress_networking.outputs.ApplicationTierSecurityGroupId
}
data "aws_security_group" "data_tier_sg" {
  id = aws_cloudformation_stack.wordpress_networking.outputs.DataTierSecurityGroupId
}
data "aws_instance" "wordpress_host" {
  depends_on = [aws_cloudformation_stack.wordpress_ec2]
  instance_id = aws_cloudformation_stack.wordpress_ec2.outputs.WordPressInstanceId
}
data "aws_alb" "wordpress_alb" {
  arn = aws_cloudformation_stack.wordpress_loadbalancer.outputs.ALBArn
}
data "aws_cloudfront_distribution" "wordpress_cdn" {
  id = aws_cloudformation_stack.wordpress_cdn.outputs.DistributionId
}