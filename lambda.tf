data "archive_file" "lambda_zip" {
  type                    = "zip"
  source_content          = "${file("${path.module}/lambda/index.js")}"
  source_content_filename = "index.js"
  output_path             = "disable_srcdstcheck.zip"
}

resource "aws_lambda_function" "disable_srcdstcheck" {
  function_name    = "${local.function_name}"
  description      = "Function that disables Source destination check of EC2 instances. ${local.description_sufix}"
  filename         = "${data.archive_file.lambda_zip.output_path}"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  role             = "${aws_iam_role.lambda.arn}"
  handler          = "index.handler"
  runtime          = "nodejs8.10"
  timeout          = 10
  tags             = "${local.tags}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.disable_srcdstcheck.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.asg_instance_launching.arn}"
}
