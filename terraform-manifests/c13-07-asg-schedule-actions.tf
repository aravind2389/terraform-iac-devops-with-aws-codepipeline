## Create Schedule Action-1: Increase Capacity during business hours
resource "aws_autoscaling_schedule" "increase_Capacity_9am" {
  scheduled_action_name  = "increase_Capacity_9am"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 8
  start_time             = "2022-12-11T09:00:00Z"
  recurrence             = "00 09 * * *" 
  autoscaling_group_name = module.autoscaling.autoscaling_group_id
}


## create Schedule Action-1: Decrease capacity during non-busisness hours
resource "aws_autoscaling_schedule" "decrease_Capacity_9pm" {
  scheduled_action_name  = "decrease_Capacity_9pm"
  min_size               = 2
  max_size               = 10
  desired_capacity       = 3
  start_time             = "2022-12-11T21:00:00Z"
  recurrence             = "00 21 * * *" 
  autoscaling_group_name = module.autoscaling.autoscaling_group_id
}
