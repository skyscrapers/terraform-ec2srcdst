resource "aws_cloudwatch_event_rule" "asg_instance_launching" {
  description = "Capture instance launching lifecycle actions with 'disable-srcdstcheck' name. ${local.description_sufix}"

  event_pattern = <<PATTERN
{
  "source": [ "aws.autoscaling" ],
  "detail-type": [ "EC2 Instance-launch Lifecycle Action" ],
  "detail": {
    "LifecycleHookName": [ "disable-srcdstcheck" ],
    "AutoScalingGroupName": [ ${join(",", formatlist("\"%s\"", var.autoscaling_group_names))} ]
  }
}
PATTERN

  tags = "${local.tags}"
}

resource "aws_cloudwatch_event_target" "asg_instance_launching" {
  rule = "${aws_cloudwatch_event_rule.asg_instance_launching.name}"
  arn  = "${aws_lambda_function.disable_srcdstcheck.arn}"
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = "${var.lambda_log_retention_in_days}"
  tags              = "${local.tags}"
}
