data "aws_iam_policy" "wordpress-ec2-log-streamer" {
  arn = aws_cloudformation_stack.wordpress_logging.outputs.WordpressEc2LogWriterManagedPolicy
}
data "aws_iam_policy" "wordpress-ec2-secrets-access" {
  arn = aws_cloudformation_stack.wordpress_secrets.outputs.WordpressEc2SecretsAccessManagedPolicy
}
data "aws_iam_policy" "wordpress-ec2-config-access" {
  arn = aws_cloudformation_stack.wordpress_config.outputs.WordpressEc2ConfigAccessManagedPolicy
}
/*
data "aws_s3_bucket_policy" "alb-log-streamer" {
  arn = aws_cloudformation_stack.wordpress_s3.outputs.ALBLogPolicyArn
  bucket =
}
data "aws_iam_policy" "cdn-log-streamer" {
  arn = aws_cloudformation_stack.wordpress_s3.outputs.CloudFrontLogPolicyArn
}
*/