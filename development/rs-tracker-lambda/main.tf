resource "aws_lambda_function" "rs_tracker_lamda" {
    filename         = "rs_tracker_lambda.zip"
    function_name    = "rs_tracker_lambda"
    role             = "arn:aws:iam::474307705618:role/RsTrackerLambda"
    handler          = "rs_tracker_lambda.lambda_handler"
    source_code_hash = "${base64sha256("rs_tracker_lambda.zip")}"
    runtime          = "python3.6"
    timeout = "30"
  
    environment {
        variables = {
            username = "woofythedog"
        }
    }
}