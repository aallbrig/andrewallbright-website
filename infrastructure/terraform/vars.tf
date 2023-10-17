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