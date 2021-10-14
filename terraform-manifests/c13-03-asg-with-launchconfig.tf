module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "4.1.0"

  # Autoscaling group
  name            = "${local.name}-"
  use_name_prefix = false

  min_size                  = 2
  max_size                  = 10
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = module.vpc.private_subnets
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn
 # ASSOCIATE ALB with ASG 
  target_group_arns         = module.alb.target_group_arns

  #CREATE LIFE_CYCLE HOOKS
  initial_lifecycle_hooks = [
    {
      name                 = "ExampleStartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "ExampleTerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]

  # ASG INSTANCE REFRESH
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag", "desired_capacity"]
  }

  # Launch configuration
  lc_name   = "${local.name}-mylc1"
  use_lc    = true
  create_lc = true

  image_id          = data.aws_ami.amzlinux.id
  instance_type     = var.instance_type
  user_data         = file("${path.module}/app1-install.sh")
  ebs_optimized     = true
  enable_monitoring = true

  #iam_instance_profile_arn    = aws_iam_instance_profile.ssm.arn
  security_groups             = [module.private_sg.security_group_id]
  associate_public_ip_address = false

  spot_price        = "0.016"

  #INSTANCE STORAGE - BLOCK DEVICES
  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      delete_on_termination = true
      encrypted             = true
      volume_type           = "gp2"
      volume_size           = "8"
    },
  ]

  root_block_device = [
    {
      delete_on_termination = true
      encrypted             = true
      volume_size           = "8"
      volume_type           = "gp2"
    },
  ]

  # METADATA HTTP OPTIONS
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 32
  }

  tags        = local.asg_tags
}