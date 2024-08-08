resource "aws_cloudwatch_dashboard" "BetterReads-Dashboard" {
  dashboard_name = "BetterReads-Holistic-Dashboard"

  dashboard_body = jsonencode({
    widgets = [

       {
        type   = "text"
        x      = 0
        y      = 0
        width  = 24
        height = 1

        properties = {
          markdown = "## EC2 Management"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", "${var.ec2_instance_id}"]
          ]
          period = 10
          stat   = "Average"
          region = "ap-southeast-2"
          title  = "EC2 Instance 1 - CPU Utilization: (${var.ec2_instance_id})"
        }
      },
      {
        type   = "metric"
        x      = 13
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["AWS/EC2", "NetworkIn", "InstanceId", "${var.ec2_instance_id}"]
          ]
          period = 10
          stat   = "Average"
          region = "ap-southeast-2"
          title  = "EC2 Instance 1 - Network In: (${var.ec2_instance_id})"
        }
      }
    ]
  })
}