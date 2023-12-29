# ----------------------------------------------------------
# Lambda Outputs
# ----------------------------------------------------------

output "lambda_function_name" {
  value = aws_lambda_function.helloworld.function_name
}

output "lambda_version" {
  value = aws_lambda_function.helloworld.version
}

output "lambda_alias_name" {
  value = aws_lambda_alias.helloworld.name
}

output "lambda_alias_version" {
  value = aws_lambda_alias.helloworld.function_version
}

output "lambda_function_arn" {
  value = aws_lambda_function.helloworld.arn
}

# ----------------------------------------------------------
# Lambda Outputs
# ----------------------------------------------------------

output "apigw_base_url" {
  description = "Base URL for API Gateway stage."
  value       = "${aws_apigatewayv2_stage.prod.invoke_url}/hello"
}
