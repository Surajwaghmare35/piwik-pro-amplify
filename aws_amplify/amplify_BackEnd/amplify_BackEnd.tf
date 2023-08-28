variable "amplify_app_id" {}
variable "backend_env" {}
variable "deployment_artifacts" {}
variable "stack_name" {}

resource "aws_amplify_backend_environment" "theme" {
  app_id           = var.amplify_app_id
  environment_name = var.backend_env

  deployment_artifacts = var.deployment_artifacts
  stack_name           = var.stack_name
}
