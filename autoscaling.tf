resource "aws_autoscaling_lifecycle_hook" "instance_launching" {
  count                  = "${var.autoscaling_group_count}"
  name                   = "disable-srcdstcheck"
  autoscaling_group_name = "${var.autoscaling_group_names[count.index]}"
  default_result         = "ABANDON"
  heartbeat_timeout      = 120                                           # 2 minutes
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"
}
