variable "amplify_app_id" {}
variable "amplify_branch" {}
variable "amplify_branch_arn" {}
variable "sns_endpoint" {}

# SNS Topic for Amplify notifications

resource "aws_sns_topic" "amplify_app_master" {
  name = "amplify-${var.amplify_app_id}_${var.amplify_branch}"
}

data "aws_iam_policy_document" "amplify_app_master" {
  statement {
    sid = "Allow_Publish_Events ${var.amplify_branch_arn}"

    effect = "Allow"

    actions = [
      "SNS:Publish",
    ]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
      ]
    }

    resources = [
      aws_sns_topic.amplify_app_master.arn,
    ]
  }
}

output "sns_topic_arn" { value = aws_sns_topic.amplify_app_master.arn }

resource "aws_sns_topic_policy" "amplify_app_master" {
  arn    = aws_sns_topic.amplify_app_master.arn
  policy = data.aws_iam_policy_document.amplify_app_master.json
}

resource "aws_sns_topic_subscription" "this" {
  topic_arn = aws_sns_topic.amplify_app_master.arn
  protocol  = "email"
  endpoint  = var.sns_endpoint
}
