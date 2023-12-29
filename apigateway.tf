resource "aws_apigatewayv2_api" "main" {
  name          = var.apig_name
  protocol_type = var.apig_protocol
}

resource "aws_apigatewayv2_stage" "prod" {
  api_id = aws_apigatewayv2_api.main.id

  name        = var.apig_stage_name
  auto_deploy = var.apig_stage_autoDeploy

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.main_api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}


//integration between the API Gateway and the Lambda function
resource "aws_apigatewayv2_integration" "apigw_lambda_handler" {
  api_id           = aws_apigatewayv2_api.main.id
  description      = var.apig_integration_description
  integration_type = var.apig_integration_type
  integration_uri  = "${aws_lambda_function.helloworld.arn}:${aws_lambda_alias.helloworld.name}"
}

//route for the API Gateway
resource "aws_apigatewayv2_route" "post_handler" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = var.apig_route_key

  target = "integrations/${aws_apigatewayv2_integration.apigw_lambda_handler.id}"
}

//cloudwatch log-group for api gateway
resource "aws_cloudwatch_log_group" "main_api_gw" {
  name = "/aws/api-gw/${aws_apigatewayv2_api.main.name}"

  retention_in_days = var.apig_CW_retention
}

//API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "apigw_lambda_invoker" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.helloworld.function_name
  principal     = "apigateway.amazonaws.com"
  qualifier     = aws_lambda_alias.helloworld.name

  source_arn = "${aws_apigatewayv2_api.main.execution_arn}/*/*"
}