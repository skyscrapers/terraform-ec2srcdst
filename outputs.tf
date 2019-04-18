output "lambda_function_name" {
  description = "Name of the created Lambda function"
  value       = "${aws_lambda_function.disable_srcdstcheck.function_name}"
}

output "lambda_cloudwatch_log_group_name" {
  description = "Name of the created Cloudwatch log group for the Lambda function"
  value       = "${aws_cloudwatch_log_group.lambda.name}"
}
