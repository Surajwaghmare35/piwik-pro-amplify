# data "aws_cognito_user_pools" "selected" {
#   name = "ThemeApp-master"
# }

# data "aws_cognito_user_pool_client" "client" {
#   client_id    = "30mmdl5g8isdgctb1s1n1god4q"
#   user_pool_id = "eu-west-1_kg0TuSYoE"
# }

resource "aws_cognito_user_pool" "pool" {
  name = "CognitoUserPool"
}

output "CognitoUserPoolID" {
  value = aws_cognito_user_pool.pool.id
}