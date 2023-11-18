resource "aws_kms_key" "lifinance-app-kms" {
  description             = "lifinance-app-kms"
  deletion_window_in_days = 7
}

resource "aws_cloudwatch_log_group" "lifinance-app-log-group" {
  name = "lifinance-app-log-group"
}

#  ECS cluster, service and task definition
resource "aws_ecs_cluster" "lifinance-cluster" {
  name = "lifinance-cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.lifinance-app-kms.arn
      logging    = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.lifinance-app-log-group.name
      }
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "lifinance-cp" {
  cluster_name = aws_ecs_cluster.lifinance-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 50
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "lifinance-task-definition" {
  family = "lifinance-td"
  network_mode = "awsvpc"
  cpu       = 1024
  memory    = 2048
  execution_role_arn = aws_iam_role.lifinance-role.arn
  container_definitions = templatefile("container-definition/definition.json", {
    posgress_password_arn = var.posgress_password_arn
    posgress_endpoint_arn = var.posgress_endpoint_arn
    redis_token_arn = var.redis_auth_arn
    redis_endpoint_arn = var.redis_endpoint_arn
    db_user_name = var.db_user_name
    awslogs_group = aws_cloudwatch_log_group.lifinance-app-log-group.name
  })
}

resource "aws_ecs_service" "lifinance-service" {
  name            = "lifinance"
  cluster         = aws_ecs_cluster.lifinance-cluster.id
  task_definition = aws_ecs_task_definition.lifinance-task-definition.arn
  desired_count   = 1
  deployment_maximum_percent         = 200
  depends_on = [
    aws_iam_policy.lifinance-policy  
  ]

  load_balancer {
    target_group_arn = aws_lb_target_group.lifinance-tg.arn
    container_name   = "lifinance-node-app"
    container_port   = 4005
  }

  network_configuration {
    subnets = var.private_subnets
    security_groups = [aws_security_group.private.id]
    assign_public_ip = true
  }
}

# Add autoscaling
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 2
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.lifinance-cluster.name}/${aws_ecs_service.lifinance-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace
 
  target_tracking_scaling_policy_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ECSServiceAverageCPUUtilization"
   }
 
   target_value       = 60
  }
}

