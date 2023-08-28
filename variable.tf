# Edit Below Amplify FrontEnd Config

variable "aws_region" { default = "eu-west-1" }

variable "app_name" { default = "piwik-pro-amplify" }

variable "git_branch" { default = "master" }

variable "amplify_framework" { default = "React" }

variable "amplify_stage" { default = "PRODUCTION" }

# Git Repo Url For FrondEnd
variable "https_repo_url" { default = "https://github.com/suraj-gatha/piwik-pro-amplify.git" }

# Git Branch Access Token
variable "access_token" { default = "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" }

variable "react_api_url" { default = "https://api.example.com" }

variable "amplify_domain" { default = "suraj.gatha.info" }

# OPTIONAL
variable "domain_prefix" { default = "piwik" }

# Edit Below Amplify BackEnd Config

variable "backend_env" { default = "staging" }
variable "deployment_artifacts" { default = "app-theme-deployment" }
variable "stack_name" { default = "amplify-app-theme" }

# Amplify Email Endpoint for SNS
variable "sns_endpoint" { default = "suraj@gatha.co.in" }
