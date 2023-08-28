variable "amplify_role_name" {}

# data "aws_iam_policy" "theme" {
#   arn = "arn:aws:iam::aws:policy/AdministratorAccess-Amplify"
# }

resource "aws_iam_role" "theme" {
  name                  = var.amplify_role_name
  force_detach_policies = true //default is "false"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "amplify.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess-Amplify"]
}

output "amplify_role_arn" { value = aws_iam_role.theme.arn }

# resource "aws_iam_role_policy_attachment" "theme-attach" {
#   role       = aws_iam_role.theme.name
#   policy_arn = data.aws_iam_policy.theme.arn
# }
