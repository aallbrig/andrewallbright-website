data "aws_iam_policy" "wordpress-ec2-log-streamer" {
  arn = aws_cloudformation_stack.wordpress_logging.outputs.WordpressEc2LogWriterManagedPolicy
}
data "aws_iam_policy" "wordpress-ec2-secrets-access" {
  arn = aws_cloudformation_stack.wordpress_secrets.outputs.WordpressEc2SecretsAccessManagedPolicy
}
data "aws_iam_policy" "wordpress-ec2-config-access" {
  arn = aws_cloudformation_stack.wordpress_config.outputs.WordpressEc2ConfigAccessManagedPolicy
}
