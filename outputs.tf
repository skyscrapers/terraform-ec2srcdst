output "lambda_function_name" {
  description = "Name of the created Lambda function"
  value       = "${aws_lambda_function.disable_srcdstcheck.function_name}"
}

output "lambda_cloudwatch_log_group_name" {
  description = "Name of the created Cloudwatch log group for the Lambda function"
  value       = "${aws_cloudwatch_log_group.lambda.name}"
}

output "cloudwatch_event_target_id" {
  description = "The unique target assignment ID for the CloudWatch event target"
  value       = "${aws_cloudwatch_event_target.asg_instance_launching.target_id}"
}

output "autoscaling_group_initial_lifecycle_hook" {
  description = "Configuration block to add to the `initial_lifecycle_hook` argument on the autoscaling groups"

  value = {
    name                 = "disable-srcdstcheck"
    default_result       = "ABANDON"
    heartbeat_timeout    = 120                                  # 2 minutes
    lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  }
}
