# DevOps CI/CD IaC BlueGreen
## 📃 Description

This is a simple “Hello World!” project, using API-Gateway for the API, Lambda for the application and CodeDeploy for the BlueGreen deployment.

The project uses GitHub for `Continuous-Integration(CI)` and CircleCI for `Continuous-Delivery(CD)`. Although, both GitHub and CircleCI are capable of entire CI/CD workflows, here CI on the GitHub and CD on the CircleCI, are separated for the illustration purpose only. The `Infrastructure-as-code(IaC)` uses the HashiCorp Terraform, configured with AWS S3 and DynamoDB for the backend.

## 🗝 Prerequisite
- Terraform [installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)  
- Access to the AWS [account](https://aws.amazon.com/resources/create-account/) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for the Terraform for provisioning AWS resources  (Note: Make sure you are familiar with the [least privileged access](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html) )
- Create an S3 bucket and a DynamoDB table for the [Terraform backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
- The GitHub-actions uses [GitHub Token](https://docs.github.com/en/enterprise-server@3.9/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) for pushing changes to the repository
- Create the CircleCI [account](https://circleci.com/signup/) and connect to the GitHub. Setup [access](https://circleci.com/docs/deploy-to-aws/) to the AWS for Continuous-Delivery (CD) Terraform provisioning.
- Pre-commit installed for the [local tests](https://pre-commit.com/) and [GitHub-actions](https://github.com/antonbabenko/pre-commit-terraform) to trigger on any changes to the Terraform provisioned resources  

### 🔩 Deployment Process

Terraform provisions all the resources.

#### Step 1.
The Python based Lambda hosts the application code, to display a simple "Hello World!" message. The API Gateway serves as the Http API proxy to forward requests to the Lambda.

![Step1](doc/Step1_APIG_codeDeploy_lambda.svg)

#### Step 2.

On subsequent Terraform provisioning resources, any changes to the code in the Lambda function, Terraform triggers CodeDeploy to update Lambda version tied to specific alias. The CodeDeploy starts to shift the traffic to the new-verison🟢 of the Lambda, in linear order at 10% every 2 minutes, in  Blue-Green🔵🟢 deployment environment. The CodeDeploy makes it easier to control the deployments, as it comes with various hooks for the different stages of the deployment. The CodeDeploy in the AWS Console can be used to monitor the deployment. In-case of failures, the deployment can be reverted, and 100% traffic pointed back to the older-version🔵 of the Lambda. The logging from the CodeDeploy and Lambda goes to the Cloudwatch, from where further monitoring can be put in place. The XRay-tracing also has been enabled to trace the requests coming to the Lambda versions for monitoring and fine-tuning purposes.

There are [default Deployment Configurations](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html#deployment-configuration-lambda) available for the Lambda in the CodeDeploy and there are below type of deployment methods available via Terraform for the CodeDeploy:

- Linear
- Canary
- All at once

![Step2](doc/Step2_APIG_codeDeploy_lambda.svg)

### 🔂 Continuous-Integration (CI)

Continuous-Integration (CI) pipeline used below tools:

**Pyetest:** for the Python unit testing of the lambda function's Python code, deployed via GitHub-actions `.github/workflows/ci.yaml`

**Coverage:** to show/report the tests coverage of the Pytest, deployed via GitHub-actions `.github/workflows/ci.yaml`

**Ruff:**  linter that checks Python cofe for programming errors, bugs, stylistic errors, and suspect constructs, deployed via GitHub-actions `.github/workflows/ci.yaml`

**Pre_commit:** runs at each commit on the Terraform file changes, first locally, then also via  GitHub-actions `.github/workflows/pre-commit.yml`, configured using `.pre-commit-config.yaml` configurations file, to perfrom below workflows:
- **Terraform fmt:** format the Terraform HCL code
- **Terraform validate:** validate the Terraform HCL code
- **tflint:** lint the Terraform code
- **trivy:** scans for security vulnerabilities and best coding practice for the Terraform HCL code
- **Terraformdocs:** to generate the documentation for the Terraform HCL code and add the report at the bottom of this `readme.md` file

**AutoTag:**: bumps repository version on any push to any branch

###### There are below GitHub-actions workflows in this pipeline:

`.github/workflows/pre-commit.yml`: runs on any push to any branch, except tags. 

`.github/workflows/ci.yaml`: runs on any push to any branch, except tags.

`.github/workflows/autotag.yml`: runs after successfully running both `.github/workflows/ci.yaml` and `.github/workflows/pre-commit.yml` GitHub-action workflows to auto bump/tag repository version on each push to any branch.


### 🏗️ Continuous-Delivery (CD)

`.circleci/config.yml`: GitHub-action workflow runs on any push to **main** branch, but not push of tags. It triggers the Continuous-Delivery (CD) pipeline on the CircleCI for provisioning AWS resources using Terraform.

**CircleCI:** It runs first run checks and validations on the Terraform code. If previous workflow was successfull, it then creates a Terraform plan file, that it carries to next the workflows. It require manual appovals for **apply** and **destroy** workflows. 

## 🗃️ Code structure
```
├── apigateway.tf
├── codedeploy.tf
├── coverage.svg
├── coverage.xml
├── doc
│   ├── Step1_APIG_codeDeploy_lambda.svg
│   └── Step2_APIG_codeDeploy_lambda.svg
├── lambda.tf
├── outputs.tf
├── providers.tf
├── PULL_REQUEST_TEMPLATE
│   └── PULL_REQUEST.md
├── README.md
├── requirements.txt
├── src
│   ├── main.py
│   └── upload
├── tests
│   ├── __init__.py
│   └── unit
│       ├── __init__.py
│       └── test_main.py
├── upload
│   └── lambda.zip
└── variables.tf
```
## 🔮 Improvements
- Use OIDC for AWS Credentials on CircleCI
- Caching client requests for replays
- Auto revert deployment on high number of failures

## 📑 Terraform Documentation

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.2 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.4.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.23.1 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | 2.4.1 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.23.1 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.2 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_integration.apigw_lambda_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.post_handler](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_cloudwatch_log_group.main_api_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_codedeploy_app.helloworld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.helloworld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_iam_role.codedeploy_deployment_group_helloworld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_helloworld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.codedeploy_deployment_group_helloworld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda_basic_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_alias.helloworld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_alias) | resource |
| [aws_lambda_function.helloworld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.apigw_lambda_invoker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [null_resource.run_codedeploy](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [archive_file.helloworld](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apig_CW_retention"></a> [apig\_CW\_retention](#input\_apig\_CW\_retention) | Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire | `number` | `7` | no |
| <a name="input_apig_integration_description"></a> [apig\_integration\_description](#input\_apig\_integration\_description) | Description of the integration | `string` | `"CodeDeploy helloworld"` | no |
| <a name="input_apig_integration_type"></a> [apig\_integration\_type](#input\_apig\_integration\_type) | Integration type of an integration. Valid values: AWS (supported only for WebSocket APIs), AWS\_PROXY, HTTP (supported only for WebSocket APIs), HTTP\_PROXY, MOCK (supported only for WebSocket APIs). For an HTTP API private integration, use HTTP\_PROXY | `string` | `"AWS_PROXY"` | no |
| <a name="input_apig_name"></a> [apig\_name](#input\_apig\_name) | API name | `string` | `"helloworld"` | no |
| <a name="input_apig_protocol"></a> [apig\_protocol](#input\_apig\_protocol) | API protocol. Valid values: HTTP, WEBSOCKET | `string` | `"HTTP"` | no |
| <a name="input_apig_route_key"></a> [apig\_route\_key](#input\_apig\_route\_key) | Route key for the route. For HTTP APIs, the route key can be either $default, or a combination of an HTTP method and resource path, for example, GET /pets | `string` | `"GET /hello"` | no |
| <a name="input_apig_stage_autoDeploy"></a> [apig\_stage\_autoDeploy](#input\_apig\_stage\_autoDeploy) | Whether updates to an API automatically trigger a new deployment. Defaults to false. Applicable for HTTP APIs | `bool` | `true` | no |
| <a name="input_apig_stage_name"></a> [apig\_stage\_name](#input\_apig\_stage\_name) | Name of the stage. Must be between 1 and 128 characters in length | `string` | `"production"` | no |
| <a name="input_codedeploy_IAMRole_name"></a> [codedeploy\_IAMRole\_name](#input\_codedeploy\_IAMRole\_name) | codedeploy IAM Role name | `string` | `"helloworldCodeDeployDeploymentGroupRole"` | no |
| <a name="input_codedeploy_app_name"></a> [codedeploy\_app\_name](#input\_codedeploy\_app\_name) | codeploy app name | `string` | `"helloworldApp"` | no |
| <a name="input_codedeploy_deploymentConfig"></a> [codedeploy\_deploymentConfig](#input\_codedeploy\_deploymentConfig) | default codedeploy deployment config | `string` | `"CodeDeployDefault.LambdaLinear10PercentEvery2Minutes"` | no |
| <a name="input_codedeploy_deploymentGroup_name"></a> [codedeploy\_deploymentGroup\_name](#input\_codedeploy\_deploymentGroup\_name) | codedeploy deployment group name | `string` | `"helloworldDeploymentGroup"` | no |
| <a name="input_codedeploy_deploymentGroup_taffic"></a> [codedeploy\_deploymentGroup\_taffic](#input\_codedeploy\_deploymentGroup\_taffic) | Indicates whether to route deployment traffic behind a load balancer. Valid Values are WITH\_TRAFFIC\_CONTROL or WITHOUT\_TRAFFIC\_CONTROL. Default is WITHOUT\_TRAFFIC\_CONTROL | `string` | `"WITH_TRAFFIC_CONTROL"` | no |
| <a name="input_codedeploy_deploymentGroup_type"></a> [codedeploy\_deploymentGroup\_type](#input\_codedeploy\_deploymentGroup\_type) | Indicates whether to run an in-place deployment or a blue/green deployment. Valid Values are IN\_PLACE or BLUE\_GREEN. Default is IN\_PLACE | `string` | `"BLUE_GREEN"` | no |
| <a name="input_lambda_alias_name"></a> [lambda\_alias\_name](#input\_lambda\_alias\_name) | alias of lambda | `string` | `"live"` | no |
| <a name="input_lambda_function_name"></a> [lambda\_function\_name](#input\_lambda\_function\_name) | name for the lambda function | `string` | `"helloworldLambda"` | no |
| <a name="input_lambda_function_runtime_python"></a> [lambda\_function\_runtime\_python](#input\_lambda\_function\_runtime\_python) | python  version for lambda | `string` | `"python3.10"` | no |
| <a name="input_lambda_publish"></a> [lambda\_publish](#input\_lambda\_publish) | Whether to publish creation/change as new Lambda Function Version. Default:false | `bool` | `true` | no |
| <a name="input_lambda_role_name"></a> [lambda\_role\_name](#input\_lambda\_role\_name) | Lambda IAM role name | `string` | `"helloworldLambdaRole"` | no |
| <a name="input_lambda_timeout"></a> [lambda\_timeout](#input\_lambda\_timeout) | duration lambda runs | `string` | `"10"` | no |
| <a name="input_lambda_xray_tracing_mode"></a> [lambda\_xray\_tracing\_mode](#input\_lambda\_xray\_tracing\_mode) | enables xray tracing for lambda Active/Passthrough | `string` | `"Active"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"eu-west-2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apigw_base_url"></a> [apigw\_base\_url](#output\_apigw\_base\_url) | Base URL for API Gateway stage. |
| <a name="output_lambda_alias_name"></a> [lambda\_alias\_name](#output\_lambda\_alias\_name) | Lambda Function Alias Name |
| <a name="output_lambda_alias_version"></a> [lambda\_alias\_version](#output\_lambda\_alias\_version) | Lambda Function Alias Version |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | Lambda Function ARN |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | Lambda Function Name |
| <a name="output_lambda_version"></a> [lambda\_version](#output\_lambda\_version) | Lambda Function Version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->