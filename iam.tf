data "aws_iam_policy_document" "lambda_assume" {
  statement {
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda" {
  name_prefix        = "srcdstcheck-lambda-"
  description        = "Role that enables lambda to disable the source destination check of EC2 instances. ${local.description_sufix}"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume.json}"
  tags               = "${local.tags}"
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "ec2:ModifyInstanceAttribute",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    actions = [
      "autoscaling:CompleteLifecycleAction",
    ]

    resources = [
      "${data.aws_autoscaling_group.targets.*.arn}",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:*:*:*",
    ]
  }
}

resource "aws_iam_role_policy" "lambda" {
  role   = "${aws_iam_role.lambda.id}"
  policy = "${data.aws_iam_policy_document.lambda.json}"
}
