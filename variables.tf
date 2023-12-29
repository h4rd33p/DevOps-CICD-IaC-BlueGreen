# ----------------------------------------------------------
# AWS Variables
# ----------------------------------------------------------

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-1"
}

# ----------------------------------------------------------
# Lambda Variables
# ----------------------------------------------------------

variable "lambda_function_name" {
  description = "name for the lambda function"
  type        = string
  default     = "helloworldLambda"
}

variable "lambda_alias_name" {
  description = "alias of lambda"
  type        = string
  default     = "live"
}

variable "lambda_timeout" {
  description = "duration lambda runs"
  type        = string
  default     = "10"
}

variable "lambda_xray_tracing_mode" {
  description = "enables xray tracing for lambda Active/Passthrough"
  type        = string
  default     = "Active"
}

variable "lambda_publish" {
  description = "Whether to publish creation/change as new Lambda Function Version. Default:false"
  type        = bool
  default     = true
}

variable "lambda_role_name" {
  description = "Lambda IAM role name"
  type        = string
  default     = "helloworldLambdaRole"
}

variable "lambda_function_runtime_python" {
  description = "python  version for lambda"
  type        = string
  default     = "python3.10"
}

# ----------------------------------------------------------
# CodeDeploy Variables
# ----------------------------------------------------------

variable "codedeploy_app_name" {
  description = "codeploy app name"
  type        = string
  default     = "helloworldApp"
}

variable "codedeploy_deploymentGroup_name" {
  description = "codedeploy deployment group name"
  type        = string
  default     = "helloworldDeploymentGroup"
}

# CodeDeploy deployment config sample from https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html
variable "codedeploy_deploymentConfig" {
  description = "default codedeploy deployment config"
  type        = string
  default     = "CodeDeployDefault.LambdaLinear10PercentEvery2Minutes"
}

variable "codedeploy_deploymentGroup_taffic" {
  description = "Indicates whether to route deployment traffic behind a load balancer. Valid Values are WITH_TRAFFIC_CONTROL or WITHOUT_TRAFFIC_CONTROL. Default is WITHOUT_TRAFFIC_CONTROL"
  type        = string
  default     = "WITH_TRAFFIC_CONTROL"
}

variable "codedeploy_deploymentGroup_type" {
  description = "Indicates whether to run an in-place deployment or a blue/green deployment. Valid Values are IN_PLACE or BLUE_GREEN. Default is IN_PLACE"
  type        = string
  default     = "BLUE_GREEN"
}

variable "codedeploy_IAMRole_name" {
  description = "codedeploy IAM Role name"
  type        = string
  default     = "helloworldCodeDeployDeploymentGroupRole"
}

# ----------------------------------------------------------
# API Gateway Variables
# ----------------------------------------------------------

variable "apig_name" {
  description = "API name"
  type        = string
  default     = "helloworld"
}

variable "apig_protocol" {
  description = "API protocol. Valid values: HTTP, WEBSOCKET"
  type        = string
  default     = "HTTP"
}

variable "apig_stage_name" {
  description = "Name of the stage. Must be between 1 and 128 characters in length"
  type        = string
  default     = "production"
}

variable "apig_stage_autoDeploy" {
  description = "Whether updates to an API automatically trigger a new deployment. Defaults to false. Applicable for HTTP APIs"
  type        = bool
  default     = true
}

variable "apig_integration_description" {
  description = "Description of the integration"
  type        = string
  default     = "CodeDeploy helloworld"
}

variable "apig_integration_type" {
  description = "Integration type of an integration. Valid values: AWS (supported only for WebSocket APIs), AWS_PROXY, HTTP (supported only for WebSocket APIs), HTTP_PROXY, MOCK (supported only for WebSocket APIs). For an HTTP API private integration, use HTTP_PROXY"
  type        = string
  default     = "AWS_PROXY"
}

variable "apig_route_key" {
  description = "Route key for the route. For HTTP APIs, the route key can be either $default, or a combination of an HTTP method and resource path, for example, GET /pets"
  type        = string
  default     = "GET /hello"
}

variable "apig_CW_retention" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, and 0. If you select 0, the events in the log group are always retained and never expire"
  type        = number
  default     = 7
}

