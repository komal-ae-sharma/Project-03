provider "aws" {
  region = "ap-south-1"
}
 
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
 
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}
 
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
 
  user_data = <<-EOF
              #!/bin/bash
              dnf install -y stress
              EOF
 
  tags = {
    Name = "Komal-Project03-EC2"
  }
}
 
resource "aws_cloudwatch_metric_alarm" "cpu_high_alarm" {
  alarm_name          = "Komal-Project03-CPU-Alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Triggers when EC2 CPU exceeds 70%"
 
  dimensions = {
    InstanceId = aws_instance.web_server.id
  }
}
 
output "instance_id" {
  value = aws_instance.web_server.id
}
 
