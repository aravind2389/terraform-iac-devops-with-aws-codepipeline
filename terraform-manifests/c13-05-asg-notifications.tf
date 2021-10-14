#SNS_TOPIC 
resource "aws_sns_topic" "myasg_sns_topic" {
  name = "myasg-sns-topic-${random_pet.this.id}"
}

#SNS_SUBSCRIPTION
resource "aws_sns_topic_subscription" "myasg_sns_topic_subscription" {
  topic_arn = aws_sns_topic.myasg_sns_topic.arn
  protocol  = "email"
  endpoint  = "aravindkundurthi98@gmail.com"
}

#CREATE AUTOSCALING NOTIFICATION RESOURCE
resource "aws_autoscaling_notification" "myasg_notifications" {
  group_names = [module.autoscaling.autoscaling_group_id ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.myasg_sns_topic.arn
}