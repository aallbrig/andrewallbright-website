variable "project_namespace" {
  description = "A namespace to prepend to all cloudformation stacks"
  type = string
  default = "andrewallbright-website"
}
variable "hosted_zone_name" {
  description = "The name of the hosted zone to use"
  type = string
  default = "andrewallbright.com"
}
variable "aws_region" {
  description = "The region to deploy to"
  type = string
  default = "us-east-2"
}
variable "ssh_key_name" {
  description = "The name of the keypair to use"
  type = string
  default = ""
}
variable "wordpress_database_host" {
  description = "The hostname of the wordpress database"
  type = string
}
variable "wordpress_database_name" {
  description = "The name of the wordpress database"
  type = string
  default = "wordpress"
}
variable "wordpress_database_username" {
  description = "The username for the wordpress database"
  type = string
  default = "wordpress"
}
variable "wordpress_database_password" {
  description = "The password for the wordpress database"
  type = string
  sensitive = true
  default = ""
}
variable "wordpress_admin_username" {
  description = "The username for the wordpress admin user"
  type = string
  default = "wp_admin"
}
variable "wordpress_admin_password" {
  description = "The password for the wordpress admin user"
  type = string
  sensitive = true
  default = ""
}
variable "wordpress_admin_email" {
    description = "The email address for the wordpress admin user"
    type = string
    default = ""
}
variable "wordpress_s3_bucket_name" {
  description = "The name of the S3 bucket to use for wordpress site (logs, content, etc). \nNote: at time of write the bucket name will have AWS AccountId prepended to bucket name"
  type = string
  default = ""
}
variable "wordpress_debug_enabled" {
  description = "Enable wordpress debug mode"
  type = bool
  default = false
}
variable "wordpress_debug_logs_enabled" {
  description = "Enable wordpress debug log mode (also requires wordpress_debug_enabled)"
  type = bool
  default = false
}
