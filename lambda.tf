# ----------------------------------------------------------
# Lambda resources
# ----------------------------------------------------------

data "archive_file" "helloworld" {
  type        = "zip"
  source_dir  = "${path.module}/src"
  output_path = "${path.module}/upload/lambda.zip"
}

resource "aws_lambda_function" "helloworld" {
  filename      = data.archive_file.helloworld.output_path
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_helloworld.arn
  handler       = "main.lambda_handler"

  source_code_hash = data.archive_file.helloworld.output_base64sha256

  runtime = var.lambda_function_runtime_python

  tracing_config {
    mode = var.lambda_xray_tracing_mode # Activate AWS X-Ray
  }

  environment {
    variables = {
      helloworld_ENV = "helloworld_VALUE"
    }
  }

  timeout = var.lambda_timeout
  publish = var.lambda_publish
}

resource "aws_lambda_alias" "helloworld" {
  name             = var.lambda_alias_name
  function_name    = aws_lambda_function.helloworld.function_name
  function_version = aws_lambda_function.helloworld.version

  # To use CodeDeploy, ignore change of function_version
  lifecycle {
    ignore_changes = [function_version]
  }

}

# ----------------------------------------------------------
# Lambda IAM
# ----------------------------------------------------------

resource "aws_iam_role" "lambda_helloworld" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_helloworld.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
