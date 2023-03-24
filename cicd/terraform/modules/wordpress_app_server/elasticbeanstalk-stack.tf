resource "aws_cloudformation_stack" "wordpress_elastic_beanstalk_stack" {
  name = var.wordpress_stack_name
  template_body = file("${path.module}/../../../cloudformation/wordpress-elasticbeanstalk-stack.yml")
  parameters = {
    YourIPAddress = var.source_ip_address
    DatabaseUsername = var.wordpress_database_username
    DatabasePassword = var.wordpress_database_password
    DatabaseName = var.wordpress_database_name
  }
}
