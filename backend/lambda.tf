resource "aws_iam_role" "lambda_role" {
  name = "LUGChatLambdaRole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cloudwatch" {
  role = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "dynamodb" {
  role = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

// send message

resource "aws_lambda_function" "send_message" {
  filename = "lambda-code/send_message.zip"
  source_code_hash = filebase64sha256("lambda-code/send_message.zip")
  function_name = "LUGChat-Send-Message"
  role = aws_iam_role.lambda_role.arn

  runtime = "python3.8"
  handler = "send_message.handler"
}

resource "aws_lambda_permission" "send_message_api_gateway" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.send_message.arn
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.lugchat.execution_arn}/*/*/*"
}

// get messages

resource "aws_lambda_function" "get_messages" {
  filename = "lambda-code/get_messages.zip"
  source_code_hash = filebase64sha256("lambda-code/get_messages.zip")
  function_name = "LUGChat-Get-Messages"
  role = aws_iam_role.lambda_role.arn

  runtime = "python3.8"
  handler = "get_messages.handler"
}

resource "aws_lambda_permission" "get_message_api_gateway" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:invokeFunction"
  function_name = aws_lambda_function.get_messages.arn
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.lugchat.execution_arn}/*/*/*"
}

