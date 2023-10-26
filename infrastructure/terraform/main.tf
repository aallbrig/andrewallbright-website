resource "aws_cloudformation_stack" "wordpress_networking" {
  name = format("%s-%s", var.project_namespace, "wordpress-networking")

  template_body = file("${path.module}/../cloudformation/wordpress_networking.yaml")

  parameters = {
    VpcId = data.aws_vpc.default_vpc.id
    WebTierSubnetAAzId = local.az_a
    WebTierSubnetBAzId = local.az_b
    WebTierACidrBlock = local.web_tier_subnet_a_cidr
    WebTierBCidrBlock = local.web_tier_subnet_b_cidr
    ApplicationTierCidrBlock = local.application_tier_subnet_cidr
    DataTierCidrBlock = local.data_tier_subnet_cidr
  }
}

resource "aws_cloudformation_stack" "wordpress_s3" {
  name = format("%s-%s", var.project_namespace, "wordpress-s3")

  template_body = file("${path.module}/../cloudformation/wordpress_s3.yaml")
  capabilities = ["CAPABILITY_IAM"]

  parameters = {
    S3BucketName: var.wordpress_s3_bucket_name
  }
}

resource "aws_cloudformation_stack" "wordpress_logging" {
  name = format("%s-%s", var.project_namespace, "wordpress-logging")

  template_body = file("${path.module}/../cloudformation/wordpress_logging.yaml")
  capabilities = ["CAPABILITY_IAM"]
}

resource "aws_cloudformation_stack" "wordpress_secrets" {
  name = format("%s-%s", var.project_namespace, "wordpress-secrets")

  template_body = file("${path.module}/../cloudformation/wordpress_secrets.yaml")
  capabilities = ["CAPABILITY_NAMED_IAM"]

  parameters = {
    DatabasePassword = var.wordpress_database_password
    WordPressAdminPassword = var.wordpress_admin_password
  }
}

resource "aws_cloudformation_stack" "wordpress_config" {
  name = format("%s-%s", var.project_namespace, "wordpress-config")

  template_body = file("${path.module}/../cloudformation/wordpress_config.yaml")
  capabilities = ["CAPABILITY_IAM"]

  parameters = {
    RootNamespace: var.project_namespace
    DatabaseHost: var.wordpress_database_host
    DatabaseName: var.wordpress_database_name
    DatabaseUsername: var.wordpress_database_username
    WordPressAdminUsername: var.wordpress_admin_username
    WordPressAdminEmail: var.wordpress_admin_email
    WordPressURL: local.https_hostname
  }
}

resource "aws_cloudformation_stack" "wordpress_ec2_instanceprofile" {
  name = format("%s-%s", var.project_namespace, "wordpress-ec2-instanceprofile")

  template_body = file("${path.module}/../cloudformation/wordpress_ec2instanceprofile.yaml")
  capabilities = ["CAPABILITY_IAM"]

  parameters = {
    ManagedPolicyArnList: join(",", [
      data.aws_iam_policy.wordpress-ec2-log-streamer.arn,
      data.aws_iam_policy.wordpress-ec2-secrets-access.arn,
      data.aws_iam_policy.wordpress-ec2-config-access.arn
    ])
  }
}

resource "aws_cloudformation_stack" "wordpress_ec2" {
  name = format("%s-%s", var.project_namespace, "wordpress-ec2")

  template_body = file("${path.module}/../cloudformation/wordpress_ec2.yaml")
  capabilities = ["CAPABILITY_IAM"]

  parameters = {
    SubnetId: data.aws_subnet.web_tier_subnet_a.id
    ImageId: local.wordpress_ec2_ami
    KeyName: var.ssh_key_name
    WordpressInstanceProfile: aws_cloudformation_stack.wordpress_ec2_instanceprofile.outputs.WordpressInstanceProfile
    SecurityGroupList: join(",", [
      data.aws_security_group.web_tier_sg.id,
      data.aws_security_group.application_tier_sg.id,
      data.aws_security_group.admin_sg.id
    ])

    WordpressDebug: var.wordpress_debug_enabled
    WordpressDebugLogs: var.wordpress_debug_logs_enabled
    DatabaseHostParameterName: aws_cloudformation_stack.wordpress_config.outputs.WordpressDatabaseHostParameter
    DatabaseNameParameterName: aws_cloudformation_stack.wordpress_config.outputs.WordpressDatabaseNameParameter
    DatabaseUsernameParameterName: aws_cloudformation_stack.wordpress_config.outputs.WordpressDatabaseUsernameParameter
    DatabasePasswordSecretArn: aws_cloudformation_stack.wordpress_secrets.outputs.DatabasePasswordSecretArn
    WordpressAdminEmailParameterName: aws_cloudformation_stack.wordpress_config.outputs.WordpressAdminEmailParameter
    WordpressAdminUsernameParameterName: aws_cloudformation_stack.wordpress_config.outputs.WordpressAdminUsernameParameter
    WordpressAdminPasswordSecretArn: aws_cloudformation_stack.wordpress_secrets.outputs.WordpressAdminPasswordSecretArn
    WordpressURLParameterName: aws_cloudformation_stack.wordpress_config.outputs.WordpressURLParameter
    WordpressTitleParameterName: aws_cloudformation_stack.wordpress_config.outputs.WordpressTitleParameter
  }
}

resource "aws_cloudformation_stack" "wordpress_alb_certs" {
  name = format("%s-%s-%s", var.project_namespace, "wordpress-certificate", var.aws_region)

  template_body = file("${path.module}/../cloudformation/wordpress_certificate.yaml")
  parameters = {
    DomainName: data.aws_route53_zone.website_hosted_zone.name
    HostedZoneId: data.aws_route53_zone.website_hosted_zone.zone_id
  }
}

resource "aws_cloudformation_stack" "wordpress_loadbalancer" {
  name = format("%s-%s", var.project_namespace, "wordpress-loadbalancer")

  template_body = file("${path.module}/../cloudformation/wordpress_loadbalancer.yaml")

  parameters = {
    VpcId: data.aws_vpc.default_vpc.id
    SubnetIds: join(",", [data.aws_subnet.web_tier_subnet_a.id, data.aws_subnet.web_tier_subnet_b.id])
    SecurityGroupId: data.aws_security_group.web_tier_sg.id
    EC2InstanceId: data.aws_instance.wordpress_host.id
    SiteCertificateArn: aws_cloudformation_stack.wordpress_alb_certs.outputs.WordpressSiteCertificateArn
  }
}

resource "aws_cloudformation_stack" "wordpress_cdn_certs" {
  name = format("%s-%s-%s", var.project_namespace, "wordpress-certificate", "us-east-1")
  # certificates just go into us-east-1
  provider = aws.useast1

  template_body = file("${path.module}/../cloudformation/wordpress_certificate.yaml")
  parameters = {
    DomainName: data.aws_route53_zone.website_hosted_zone.name
    HostedZoneId: data.aws_route53_zone.website_hosted_zone.zone_id
  }
}

resource "aws_cloudformation_stack" "wordpress_cdn" {
  name = format("%s-%s", var.project_namespace, "wordpress-cdn")

  template_body = file("${path.module}/../cloudformation/wordpress_cdn.yaml")
  parameters = {
    OriginDomainName: data.aws_alb.wordpress_alb.dns_name
    Aliases: join(",", [
      data.aws_route53_zone.website_hosted_zone.name,
      format("www.%s", data.aws_route53_zone.website_hosted_zone.name)
    ])
    SiteCertificateArn: aws_cloudformation_stack.wordpress_cdn_certs.outputs.WordpressSiteCertificateArn
  }
}

resource "aws_cloudformation_stack" "wordpress_hostedzone" {
  name = format("%s-%s", var.project_namespace, "wordpress-hostedzone")

  template_body = file("${path.module}/../cloudformation/wordpress_hostedzone.yaml")

  parameters = {
    HostedZoneId: data.aws_route53_zone.website_hosted_zone.zone_id
    ApexDomainName: var.hosted_zone_name
    /*
    ApexIpAddress: data.aws_instance.wordpress_host.public_ip
    */
    /*
    ApexDNSName: data.aws_alb.wordpress_alb.dns_name
    ApexDNSHostedZoneId: data.aws_alb.wordpress_alb.zone_id
    */
    ApexDNSName: data.aws_cloudfront_distribution.wordpress_cdn.domain_name
    ApexDNSHostedZoneId: data.aws_cloudfront_distribution.wordpress_cdn.hosted_zone_id
  }
}
