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
          parameters = [
            {
              in = "query"
              name = "all"
              schema = {
                type = "string"
              }
            }
          ]
          x-amazon-apigateway-integration = {
            requestParameters = {
              "integration.request.querystring.all" = "method.request.querystring.all"
            }
            httpMethod = "POST"
            payloadFormatVersion = "1.0"
            type = "AWS_PROXY"
            uri = aws_lambda_function.get_messages.invoke_arn
          }
          x-amazon-apigateway-cors = {
            allowOrigins = ["*"]
            allowMethods = ["GET", "POST", "OPTIONS"]
            allowHeaders = [
              "Content-Type",
              "X-Amz-Date",
              "Authorization",
              "X-Api-Key",
              "X-Amz-Security-Token"
            ]
          }
        }
        post = {
          x-amazon-apigateway-integration = {
            httpMethod = "POST"
            payloadFormatVersion = "1.0"
            type = "AWS_PROXY"
            uri = aws_lambda_function.send_message.invoke_arn
          }
          x-amazon-apigateway-cors = {
            allowOrigins = ["*"]
            allowMethods = ["GET", "POST", "OPTIONS"]
            allowHeaders = [
              "Content-Type",
              "X-Amz-Date",
              "Authorization",
              "X-Api-Key",
              "X-Amz-Security-Token"
            ]
          }
        }
        options = {
          consumes = [ "application/json" ]
          produces = [ "application/json" ]
          responses = {}
          x-amazon-apigateway-integration = {
            type = "MOCK"
            responses = {
              "default" = {
                "statusCode" = "200"
              }
            }
            requestTemplates = {
              "application/json" = "{\"statusCode\": 200}"
            }
            passthroughBehavior = "when_no_match"
          }
          x-amazon-apigateway-cors = {
            allowOrigins = ["*"]
            allowMethods = ["GET", "POST", "OPTIONS"]
            allowHeaders = [
              "Content-Type",
              "X-Amz-Date",
              "Authorization",
              "X-Api-Key",
              "X-Amz-Security-Token"
            ]
          }
        }
      }
    }
  })
}

resource "aws_api_gateway_model" "empty" {
  rest_api_id = aws_api_gateway_rest_api.lugchat.id
  name = "Empty"
  content_type = "application/json"
  schema = "{}"
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

