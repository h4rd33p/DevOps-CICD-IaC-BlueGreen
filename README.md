# DevOps CI/CD IaC BlueGreen
## 📃 Description

This is a simple “Hello World!” project, using the API-Gateway for API, Lambda for the application and the CodeDeploy for BlueGreen deployment type.

The project uses GitHub for `Continuous-Integration(CI)` and CircleCI for `Continuous-Delivery(CD)`. Although, both GitHub and CircleCI are capable of entire CI/CD workflows, but here CI on the GitHub and CD on the CircleCI, are divided for the illustration purpose only. The `Infrastructure-as-code(IaC)` uses the HashiCorp Terraform, configured with AWS S3 and DynamoDB for the backend.

## 🗝 Prerequisite
- Terraform [installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)  
- Access to AWS [account](https://aws.amazon.com/resources/create-account/) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for terraform to connect to the AWS (Note: Make sure you are familier with the [least privilleged access](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html) )
- Create S3 bucket and DynamoDB table for [Terraform backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
- GitHub-actions uses [GitHub Token](https://docs.github.com/en/enterprise-server@3.9/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) for bumping/tagging the version of the repository
- CircleCI [account](https://circleci.com/signup/) and connect to GitHub. Setup [access](https://circleci.com/docs/deploy-to-aws/) to AWS for Continuous-Delivery (CD) Terraform workflows.
- Pre-commit for [local tests](https://pre-commit.com/) and [GitHub tests](https://github.com/antonbabenko/pre-commit-terraform) before each commit on terraform changes  

### 🔩 Deployment Process

Terraform provision all the resources

#### Step 1.
The Python based Lambda hosts the application code to display a simple "Hello World!" message. The API Gateway serves as the Http API proxy to forward requests to the Lambda.  

![Step1](doc/Step1_APIG_codeDeploy_lambda.svg)

#### Step 2.
When  is completed and Lambda is updated, terraform triggers CodeDeploy to update Lambda version tied to specific alias.

On subsequent provisioning with any changes to the code in the Lambda function, terraform triggers CodeDeploy to update Lambda version tied to specific alias. The CodeDeploy start to shift the traffic to the new-verison[🟢] of the Lambda, in linear order as 10% every 2 minutes, as the Blue-Green[🔵🟢] Deployment. The CodeDeploy makes it easier to control the deployments, as it comes with various hooks for the different stages of the deployment. The CodeDeploy in the AWS Console can be used to monitor the deployment. In-case of failures, revert the deployment and 100% tarrfic will be pointed back to the older-version[🔵] of the Lambda. The logging from the CodeDeploy and Lambda goes to the Cloudwatch, from where further monitoring can be put in place. The XRay-tracing also has been enabled to trace the requests coming to the Lambda versions for the monitoring and fine-tuning purposes.

There are [default Deployment Configurations](https://docs.aws.amazon.com/codedeploy/latest/userguide/deployment-configurations.html#deployment-configuration-lambda) available for the Lambda in CodeDeploy and type of deployment methods available via Terraform for the CodeDeploy as below:

- Linear
- Canary
- All at once

![Step2](doc/Step2_APIG_codeDeploy_lambda.svg)

### 🔂 Continuous-Integration (CI)

Below tools where used in the Continuous-Integration (CI) Pipeline:

**Pyetest:** for the Python unit testing for the lambda function's Python code. Deployed via GitHub-actions `.github/workflows/ci.yaml`

**Coverage:** to show/report the tests coverage of Pytest. Deployed via Github actions `.github/workflows/ci.yaml`

**Pre_commit:** runs on each commit on terraform file changes, first locally, then also via  GitHub-actions `.github/workflows/pre-commit.yml`, configured using `.pre-commit-config.yaml` file, to perfrom below workflows:
- **Terraform fmt:** format the terraform HCL code
- **Terraform validate:** validate the terraform HCL code
- **tflint:** lint the terraform code
- **trivy:** scan for security vulnerbitlitiies and best coding practice for the terraform HCL code
- **terraform docs:** to generate the documentation for the terraform HCL code and add the report at the bottom of this `readme.md` file

**AutoTag:** runs after successfully running the `.github/workflows/ci.yaml` and `.github/workflows/pre-commit.yml` Github-actions workflows to auto bump/tag repository version on each push.

###  ⏯ Continuous-Delivery (CD)

**CircleCI:** hosts the Continuous-Delivery (CD) pipeline. It is integrated with the GitHub for the respository changes for PR requests and runs the terraform 




   
 :CircleCI IaC:Terraform BlueGreen-Deployment:CodeDeply
#### | API:API-Gateway | Application:Lambda | Code:Python | CI-tests:AutoTag, ruff, Pytest with coverage | Pre-commit for Local+on-commit for terraform(fmt, validate, tflint, trivy, docs | CD:CircleCI Terraform stages
### Terraform Config: State file Backend:S3, Lock file backend: DynamoDB

## Prerequisite
- Terraform [installed](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)  
- Access to AWS [account](https://aws.amazon.com/resources/create-account/) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) for terraform to connect to the AWS (Note: Make sure you are familier with the [least privilleged access](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html) )
- Create S3 bucket and DynamoDB table for [Terraform backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3)
- GitHub-actions uses [GitHub Token](https://docs.github.com/en/enterprise-server@3.9/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) for bumping/tagging the version of the repository
- CircleCI [account](https://circleci.com/signup/) and connect to GitHub. Setup [access](https://circleci.com/docs/deploy-to-aws/) to AWS for Continuous-Delivery (CD) Terraform workflows.
- Pre-commit for [local tests](https://pre-commit.com/) and [GitHub tests](https://github.com/antonbabenko/pre-commit-terraform) before each commit on terraform changes  

## Code structure
```
├── apigateway.tf
├── codedeploy.tf
├── coverage.svg
├── coverage.xml
├── lambda.tf
├── outputs.tf
├── providers.tf
├── requirements.txt
├── src
│   ├── main.py
│   │   └── main.py
│   └── upload
├── tests
│   ├── __init__.py
│   │   └── __init__.py
│   └── unit
│       ├── __init__.py
│       │   ├── __init__.py
│       │   └── test_main.py
│       └── test_main.py
├── upload
│   └── lambda.zip
└── variables.tf
```
## Improvements
- Use OIDC for AWS Credentials on CircleCI
- Caching client requests for replays
- Auto revert deployment on high number of failures

## Terraform Documentation
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->