# ----------------------------------------------------------
# CodeDeploy resources
# ----------------------------------------------------------

resource "aws_codedeploy_app" "helloworld" {
  compute_platform = "Lambda"
  name             = var.codedeploy_app_name
}

resource "aws_codedeploy_deployment_group" "helloworld" {
  app_name              = aws_codedeploy_app.helloworld.name
  deployment_group_name = var.codedeploy_deploymentGroup_name
  service_role_arn      = aws_iam_role.codedeploy_deployment_group_helloworld.arn

  deployment_config_name = var.codedeploy_deploymentConfig
  deployment_style {
    deployment_option = var.codedeploy_deploymentGroup_taffic
    deployment_type   = var.codedeploy_deploymentGroup_type
  }
}

# ----------------------------------------------------------
# Trigger of deployment
# ----------------------------------------------------------

resource "null_resource" "run_codedeploy" {
  triggers = {
    # Run codedeploy when lambda version is updated
    lambda_version = aws_lambda_function.helloworld.version
  }

  provisioner "local-exec" {
    # Only trigger deploy when lambda version is updated (=lambda version is not 1)
    command = "if [ ${aws_lambda_function.helloworld.version} -ne 1 ] ;then aws deploy create-deployment --region ${var.region} --application-name ${aws_codedeploy_app.helloworld.name} --deployment-group-name ${aws_codedeploy_deployment_group.helloworld.deployment_group_name} --revision '{\"revisionType\":\"AppSpecContent\",\"appSpecContent\":{\"content\":\"{\\\"version\\\":0,\\\"Resources\\\":[{\\\"${aws_lambda_function.helloworld.function_name}\\\":{\\\"Type\\\":\\\"AWS::Lambda::Function\\\",\\\"Properties\\\":{\\\"Name\\\":\\\"${aws_lambda_function.helloworld.function_name}\\\",\\\"Alias\\\":\\\"${aws_lambda_alias.helloworld.name}\\\",\\\"CurrentVersion\\\":\\\"${aws_lambda_alias.helloworld.name}\\\",\\\"TargetVersion\\\":\\\"${aws_lambda_function.helloworld.version}\\\"}}}]}\"}}';fi"
  }
}

# ----------------------------------------------------------
# CodeDeploy IAM
# ----------------------------------------------------------

resource "aws_iam_role" "codedeploy_deployment_group_helloworld" {
  name = var.codedeploy_IAMRole_name

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "sts:AssumeRole",
          "Principal" : {
            "Service" : "codedeploy.amazonaws.com"
          },
          "Effect" : "Allow",
        }
      ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "codedeploy_deployment_group_helloworld" {
  role       = aws_iam_role.codedeploy_deployment_group_helloworld.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambdaLimited"
}