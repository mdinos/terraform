resource "aws_iam_role" "rs_tracker_lambda_role" {
  name               = "${var.lambda_name}"
  assume_role_policy = "${data.aws_iam_policy_document.assume_rs_tracker_lambda_role.json}"
}

resource "aws_iam_role_policy" "rs_lambda_policy" {
  name   = "${var.lambda_name}"
  policy = "${data.aws_iam_policy_document.rs_lambda_policy_doc.json}"
  role   = "${aws_iam_role.rs_tracker_lambda_role.id}"
}

data "aws_iam_policy_document" "assume_rs_tracker_lambda_role" {
  statement {
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "rs_lambda_policy_doc" {
  statement {
    sid = "1"

    actions = [
      "s3:PutObject",
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.lambda_name}*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:${var.region}:${var.account_number}:log-group:/aws/lambda/${var.lambda_name}:*",
    ]
  }
}
