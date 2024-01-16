# ----------------------------------------------------------
# Lambda Outputs
# ----------------------------------------------------------

output "lambda_function_name" {
  description = "Lambda Function Name"
  value       = aws_lambda_function.helloworld.function_name
}

output "lambda_version" {
  description = "Lambda Function Version"
  value       = aws_lambda_function.helloworld.version
}

output "lambda_alias_name" {
  description = "Lambda Function Alias Name"
  value       = aws_lambda_alias.helloworld.name
}

output "lambda_alias_version" {
  description = "Lambda Function Alias Version"
  value       = aws_lambda_alias.helloworld.function_version
}

output "lambda_function_arn" {
  description = "Lambda Function ARN"
  value       = aws_lambda_function.helloworld.arn
}

# ----------------------------------------------------------
# API Gateway Outputs
# ----------------------------------------------------------

output "apigw_base_url" {
  description = "Base URL for API Gateway stage."
  value       = "${aws_apigatewayv2_stage.prod.invoke_url}/hello"
}