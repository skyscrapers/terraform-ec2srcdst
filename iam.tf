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
      "${formatlist("arn:aws:autoscaling:%s:%s:autoScalingGroup:*:autoScalingGroupName/%s", data.aws_region.current.name, data.aws_caller_identity.current.account_id, coalescelist(var.autoscaling_group_names, list("*")))}",
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
