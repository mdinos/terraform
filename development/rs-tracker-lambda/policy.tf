resource "aws_iam_role" "rs_tracker_lambda_role" {
  name = "${var.lambda_name}"
  assume_role_policy = "${data.aws_iam_policy.rs_tracker_lambda}"
}

data "aws_iam_policy_document" "rs_lambda_policy_doc" {
  statement {
    sid = "1"

    actions = [
      "s3:s3:PutObject"
    ]

    resources = [
      "arn:aws:s3:::${var.lambda_name}*",
    ]
  }

  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "arn:aws:logs:${var.region}:${var.account_number}:log-group:/aws/lambda/${var.lambda_name}:*"
    ]
  }
}

resource "aws_iam_policy" "rs_lambda_policy" {
  name   = "${var.lambda_name}"
  policy = "${data.aws_iam_policy_document.example.json}"
}