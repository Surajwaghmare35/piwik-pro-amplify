# Uncomment to configure s3 as remote-backend
terraform {
  backend "s3" {}
}

provider "aws" { region = var.aws_region }

module "amplify_frontend" {
  source            = "./aws_amplify/amplify_FrontEnd"
  app_name          = var.app_name
  git_branch        = var.git_branch
  amplify_framework = var.amplify_framework
  amplify_stage     = var.amplify_stage
  access_token      = var.access_token
  https_repo_url    = var.https_repo_url
  react_api_url     = var.react_api_url
  amplify_domain    = var.amplify_domain
  domain_prefix     = var.domain_prefix

  amplify_role_arn  = module.amplify_iam.amplify_role_arn
  CognitoUserPoolID = module.cognito.CognitoUserPoolID
}

module "amplify_backend" {
  source               = "./aws_amplify/amplify_BackEnd"
  amplify_app_id       = module.amplify_frontend.amplify_app_id
  backend_env          = var.backend_env
  deployment_artifacts = var.deployment_artifacts
  stack_name           = var.stack_name
}

module "amplify_sns" {
  source         = "./aws_amplify/aws_sns"
  amplify_app_id = module.amplify_frontend.amplify_app_id
  # git_branch     = var.git_branch
  amplify_branch     = module.amplify_frontend.amplify_branch
  amplify_branch_arn = module.amplify_frontend.amplify_branch_arn
  sns_endpoint       = var.sns_endpoint
}

module "amplify_iam" {
  source            = "./aws_amplify/aws_iam"
  amplify_role_name = "AmplifyConsoleServiceRole-AmplifyRole1"
}

module "amplify_cw" {
  source         = "./aws_amplify/aws_cw"
  amplify_app_id = module.amplify_frontend.amplify_app_id
  # git_branch     = var.git_branch
  amplify_branch = module.amplify_frontend.amplify_branch
  sns_topic_arn  = module.amplify_sns.sns_topic_arn
}

module "cognito" {
  source = "./aws_amplify/aws_cognito"
}
