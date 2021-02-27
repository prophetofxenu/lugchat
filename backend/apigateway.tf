resource "aws_api_gateway_rest_api" "lugchat" {
  name = "LUGChat"
  endpoint_configuration {
    types = ["REGIONAL"]
  }

  body = jsonencode({
    openapi = "3.0.1"
    info = {
      title = "lugchat"
      version = "1.0"
    }
    paths = {
      "/messages/{chatroom}" = {
        get = {
          x-amazon-apigateway-integration = {
            httpMethod = "GET"
            payloadFormatVersion = "1.0"
            type = "AWS_PROXY"
            uri = aws_lambda_function.get_messages.invoke_arn
          }
        }
        post = {
          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            payloadFormatVersion = "1.0"
            type = "AWS_PROXY"
            uri = aws_lambda_function.send_message.invoke_arn
          }
        }
      }
    }
  })
}

resource "aws_api_gateway_deployment" "lugchat" {
  rest_api_id = aws_api_gateway_rest_api.lugchat.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.lugchat.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "lugchat" {
  deployment_id = aws_api_gateway_deployment.lugchat.id
  rest_api_id = aws_api_gateway_rest_api.lugchat.id
  stage_name = "lugchat-stage"
}

