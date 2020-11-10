resource "aws_cloudwatch_event_target" "event_target_lambda" {
  target_id = "${var.lambda_name}-event-target"
  rule      = "${aws_cloudwatch_event_rule.run_rs_lambda.name}"
  arn       = "${aws_lambda_function.rs_tracker_lambda.arn}"
}

resource "aws_cloudwatch_event_rule" "run_rs_lambda" {
  name        = "run-${var.lambda_name}"
  description = "Trigger ${var.lambda_name} once a day"

  depends_on = [
    "aws_lambda_function.rs_tracker_lambda",
  ]

  schedule_expression = "rate(1 day)"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.rs_tracker_lambda.arn}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.run_rs_lambda.arn}"
}
