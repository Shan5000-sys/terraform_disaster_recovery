resource "aws_sns_topic" "alerts" {
  name = "dr-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "shangeeth023@gmail.com"  # ✅ Replace with your real email
}