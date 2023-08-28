resource "aws_amplify_app" "theme" {
  name       = var.app_name
  repository = var.https_repo_url

  # GitHub personal access token
  access_token = var.access_token

  # enable_auto_branch_creation = true
  enable_branch_auto_build = true

  enable_basic_auth      = true
  basic_auth_credentials = base64encode("username1:password1")

  # The default patterns added by the Amplify Console.
  auto_branch_creation_patterns = ["*", "*/**", ]

  auto_branch_creation_config {
    # Enable auto build for the created branch.
    enable_auto_build = true
    stage             = var.amplify_stage
  }

  # Deploying the BackEnd code with the FrontEnd by Amplify for React
  build_spec = <<-EOT
    version: 1
    backend:
      phases:
        build:
          commands:
            - amplifyPush --simple

    frontend:
      phases:
        preBuild:
          commands:
            - npm ci
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: build
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  # The default rewrites and redirects added by the Amplify Console.
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }
  custom_rule {
    source = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
    status = "200"
    target = "/index.html"
  }

  environment_variables = {
    ENV                 = var.amplify_stage,
    AMPLIFY_USERPOOL_ID = var.CognitoUserPoolID


  }
  iam_service_role_arn = var.amplify_role_arn
}

output "amplify_app_id" { value = aws_amplify_app.theme.id }

resource "aws_amplify_branch" "master" {
  app_id            = aws_amplify_app.theme.id
  branch_name       = var.git_branch
  enable_auto_build = true

  framework = var.amplify_framework
  stage     = var.amplify_stage

  # Enable SNS notifications.
  enable_notification = true

  environment_variables = {
    REACT_APP_API_SERVER = var.react_api_url
  }
}

output "amplify_branch" { value = aws_amplify_branch.master.branch_name }
output "amplify_branch_arn" { value = aws_amplify_branch.master.arn }

resource "aws_amplify_domain_association" "theme" {
  app_id                 = aws_amplify_app.theme.id
  domain_name            = var.amplify_domain
  enable_auto_sub_domain = true
  wait_for_verification  = true

  # https://example.com
  sub_domain {
    branch_name = aws_amplify_branch.master.branch_name
    prefix      = var.domain_prefix
  }

  # # https://www.example.com
  # sub_domain {
  #   branch_name = aws_amplify_branch.master.branch_name
  #   prefix      = "www"
  # }
}

resource "aws_amplify_webhook" "master" {
  app_id      = aws_amplify_app.theme.id
  branch_name = aws_amplify_branch.master.branch_name
  description = "triggermaster"
}
