module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  #version = "5.16.0"
  version  = "6.0.0"

  name = "${local.name}-alb"
  load_balancer_type = "application"
  vpc_id = module.vpc.vpc_id
  /*subnets = [
    module.vpc.public_subnets[0],
    module.vpc.public_subnets[1]
  ]*/
  subnets = module.vpc.public_subnets
  security_groups = [module.loadbalancer_sg.security_group_id]
 
  # Listeners
  # HTTP Listener - HTTP to HTTPS Redirect
  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      action_type        = "redirect"
      redirect = {
        port  = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]  
  # Target Groups
  target_groups = [
    # App1 Target Group - TG Index = 0
    {
      name_prefix          = "app1-"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app1/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      /*# App1 Target Group - Targets
      targets = {
        my_app1_vm1 = {
          target_id = module.ec2_private_app1.id[0]
          port      = 80
        },
        my_app1_vm2 = {
          target_id = module.ec2_private_app1.id[1]
          port      = 80
        }
      }*/

      tags =local.common_tags # Target Group Tags
    },
  ]

  /*
  # App2 Target Group - TG Index = 1
    {
      name_prefix          = "app2-"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/app2/index.html"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      # App2 Target Group - Targets
      targets = {
        my_app2_vm1 = {
          target_id = module.ec2_private_app2.id[0]
          port      = 80
        },
        my_app2_vm2 = {
          target_id = module.ec2_private_app2.id[1]
          port      = 80
        }
      }
      tags =local.common_tags # Target Group Tags
    },

    {
      name_prefix          = "app3-"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "instance"
      deregistration_delay = 10 
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/login"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      stickiness = {
        enabled = true
        cookie_duration = 86400
        type = "lb_cookie"
      }
      protocol_version = "HTTP1"
      # App3 Target Group - Targets
      targets = {
        my_app3_vm1 = {
          target_id = module.ec2_private_app3.id[0]
          port      = 8080
        },
        my_app3_vm2 = {
          target_id = module.ec2_private_app3.id[1]
          port      = 8080
        }
      }
      tags =local.common_tags # Target Group Tags
    }
  ]
  */

  #HTTPS LIisteners
  https_listeners = [   
    #HTTPS LISTENERS Index=0 for HTTPS443
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = module.acm.acm_certificate_arn
      action_type = "fixed-response"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Fixed Static message - for Root Context"
        status_code  = "200"
      }
    },
  ]

   # HTTPS Listener Rules
  https_listener_rules = [
    #Rule-1: /app1* should go to App1 to EC2 instances
    { 
      https_listener_index = 0
      priority = 1
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{
        path_patterns = ["/*"]
        #host_headers = [var.app1_dns_name]
        /*http_headers = [{
          http_header_name = "custom-header"
          values           = ["app1", "app-1", "my-app-1"]
        }]*/
      }]
    }
  ]  
    /*
    {
    #Rule-2: /app2* should go to App1 to EC2 instances  
      https_listener_index = 0
      priority = 2
      actions = [
        {
          type               = "forward"
          target_group_index = 1
        }
      ]
      conditions = [{
        path_patterns = ["/app2*"]
        #host_headers = [var.app2_dns_name]
        /*http_headers = [{
          http_header_name = "custom-header"
          values           = ["app2", "app-2", "my-app-2"]
        }]
      }]
    },
    
    #Rule-3: When Query-String, Website-aws-eks redirect to  https://stacksimplify.com/aws-eks/
    {
      https_listener_index = 0
      priority = 3
      actions = [{
        type        = "redirect"
        status_code = "HTTP_302"
        host        = "stacksimplify.com"
        path        = "/aws/eks"
        query       = ""
        protocol    = "HTTPS"
      }]
      conditions =[{
        query_strings = [{
          key     = "website"
          value   = "aws-eks"
        }]
      }]
    },
    #Rule-4: When Host Header = azure-aks.devopsincloud.com, redirect to https://stacksimplify.com/azure-aks/azure-kubernetes-service-introduction/
    {
      https_listener_index = 0
      priority = 4
      actions = [{
        type        = "redirect"
        status_code = "HTTP_302"
        host        = "stacksimplify.com"
        path        = "/azure-aks/azure-kubernetes-service-introduction/"
        query       = ""
        protocol    = "HTTPS"
      }]
      conditions =[{
        host_headers = ["azure-aks11.akintellectualmind.click"]
      }]
    }
    

     # Rule-3: /* should go to App3 - User-mgmt-WebApp EC2 Instances    
    {
      https_listener_index = 0
      priority = 3      
      actions = [
        {
          type               = "forward"
          target_group_index = 2
        }
      ]
      conditions = [{
        path_patterns = ["/*"]
      }]
    },       
  ]
  */
  tags = local.common_tags
}
