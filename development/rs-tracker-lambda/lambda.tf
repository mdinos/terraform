resource "aws_lambda_function" "rs_tracker_lambda" {
  filename         = "${var.lambda_name}.zip"
  function_name    = "${var.lambda_name}"
  role             = "${aws_iam_role.rs_tracker_lambda_role.arn}"
  handler          = "rs_tracker_lambda.lambda_handler"
  source_code_hash = "${base64sha256("${var.lambda_name}.zip")}"
  runtime          = "python3.6"
  timeout          = "30"

  environment {
    variables = {
      username = "woofythedog"
      bucket   = "${var.lambda_name}"
    }
  }
}
