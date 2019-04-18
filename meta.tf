locals {
  function_name     = "ec2srcdstcheck-${random_string.name.result}"
  description_sufix = "Autoscaling groups: ${join(", ", var.autoscaling_group_names)}"
  tags              = "${var.tags}"
}

data "aws_autoscaling_group" "targets" {
  count = "${var.autoscaling_group_count}"
  name  = "${var.autoscaling_group_names[count.index]}"
}

resource "random_string" "name" {
  length  = 16
  special = false
  upper   = false
}
