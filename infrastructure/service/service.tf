resource "aws_ecs_task_definition" "the_task_definition" {
  family                   = "${var.app_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.pod_role.arn
  task_role_arn            = aws_iam_role.pod_role.arn

  container_definitions = jsonencode([
    {
      name      = "web",
      image     = "${var.aws_account}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.app_name}:${var.app_version}"
      cpu       = 1024,
      memory    = 1024,
      essential = true,
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:8081/ping || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      },
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          "awslogs-group"         = "/ecs/${var.app_name}",
          "awslogs-region"        = "${var.aws_region}",
          "awslogs-stream-prefix" = "web"
        }
      },
      portMappings = [
        {
          containerPort = 8080,
          hostPort      = 8080,
          protocol      = "tcp"
        },
        {
          containerPort = 8081,
          hostPort      = 8081,
          protocol      = "tcp"
        }
      ],
      environment = [
        {
          name  = "AWS_REGION"
          value = "${var.aws_region}"
        },
        {
          name  = "AWS_ACCOUNT"
          value = "${var.aws_account}"
        },
        {
          name  = "STAGE"
          value = "${var.stage}"
        },
        {
          name  = "APP_NAME"
          value = "${var.app_name}"
        },
        {
          name  = "APP_VERSION"
          value = "${var.app_version}"
        }
      ],
    },
  ])
}

resource "aws_security_group" "the_service_sg" {
  name        = "${var.app_name}"
  description = "ECS Service security group"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "the_ecs_service" {
  name            = "${var.app_name}-service"
  cluster         = local.cluster_name
  task_definition = aws_ecs_task_definition.the_task_definition.arn
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.tg.arn
    container_name   = "web"
    container_port   = 8080
  }

  network_configuration {
    subnets          = local.subnet_ids
    security_groups  = [aws_security_group.the_service_sg.id]
    assign_public_ip = true
  }

  desired_count = 3

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.discoverable_service.arn
  }
}

resource "aws_cloudwatch_log_group" "the_log_group" {
  name = "/ecs/${var.app_name}"
}

# register so services can talk to each other
resource "aws_service_discovery_service" "discoverable_service" {
  name = "${var.app_name}"

  dns_config {
    namespace_id = local.namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

