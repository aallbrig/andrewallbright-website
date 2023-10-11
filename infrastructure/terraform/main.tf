resource "aws_cloudformation_stack" "wordpress_lightsail" {
  name = format("%s-%s", var.project_namespace, "wordpress-lightsail")

  template_body = file("${path.module}/../cloudformation/wordpress_lightsail.yaml")
}