locals {
  function_name     = "ec2srcdstcheck-${random_string.name.result}"
  description_sufix = "Autoscaling groups: ${join(", ", var.autoscaling_group_names)}"
  tags              = "${var.tags}"
}

resource "random_string" "name" {
  length  = 16
  special = false
  upper   = false
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
