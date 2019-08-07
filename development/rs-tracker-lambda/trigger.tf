
resource "aws_cloudwatch_event_target" "event_target_lambda" {
  target_id = "${var.lambda_name}-event-target"
  rule      = "${aws_cloudwatch_event_rule.run_rs_lambda.name}"
  arn       = "${aws_lambda_function.rs_tracker_lambda.arn}"
}

resource "aws_cloudwatch_event_rule" "run_rs_lambda" {
  name        = "run-${var.lambda_name}"
  description = "Trigger RS Tracker Lambda once a day"
  schedule_expression = rate(1 day)
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.rs_tracker_lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.run_rs_lambda.arn}"
  qualifier     = "${aws_lambda_alias.rs_lambda_alias.name}"
}

resource "aws_lambda_alias" "rs_lambda_alias" {
  name             = "${var.lambda_name}_alias"
  function_name    = "${aws_lambda_function.test_lambda.function_name}"
  function_version = "$LATEST"
}
