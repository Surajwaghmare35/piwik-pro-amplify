variable "amplify_app_id" {}
variable "amplify_branch" {}
variable "sns_topic_arn" {}

# EventBridge Rule for Amplify notifications

resource "aws_cloudwatch_event_rule" "amplify_app_master" {
  name        = "amplify-${var.amplify_app_id}-${var.amplify_branch}-branch-notification"
  description = "AWS Amplify build notifications for :  App: ${var.amplify_app_id} Branch: ${var.amplify_branch}"

  event_pattern = jsonencode({
    "detail" = {
      "appId"      = [var.amplify_app_id]
      "branchName" = [var.amplify_branch],
      "jobStatus"  = ["SUCCEED", "FAILED", "STARTED"]
    }
    "detail-type" = ["Amplify Deployment Status Change"]
    "source"      = ["aws.amplify"]
  })
}

resource "aws_cloudwatch_event_target" "amplify_app_master" {
  rule      = aws_cloudwatch_event_rule.amplify_app_master.name
  target_id = var.amplify_branch
  arn       = var.sns_topic_arn

  input_transformer {
    input_paths = {
      jobId  = "$.detail.jobId"
      appId  = "$.detail.appId"
      region = "$.region"
      branch = "$.detail.branchName"
      status = "$.detail.jobStatus"
    }

    input_template = "\"Build notification from the AWS Amplify Console for app: https://<branch>.<appId>.amplifyapp.com/. Your build status is <status>. Go to https://console.aws.amazon.com/amplify/home?region=<region>#<appId>/<branch>/<jobId> to view details on your build. \""
  }
}
