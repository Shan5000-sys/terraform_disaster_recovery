resource "aws_cloudwatch_metric_alarm" "cpu_alarm_primary" {
  alarm_name          = "HighCPUPrimary"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300                # 5 minutes
  statistic           = "Average"
  threshold           = 80                 # Trigger if > 80%
  alarm_description   = "Alarm when primary EC2 CPU > 80%"
  alarm_actions       = [aws_sns_topic.alerts.arn]  # 🚨 Link to SNS

  dimensions = {
    InstanceId = module.primary_web.instance_id
  }
}