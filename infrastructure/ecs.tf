# Latest ECR Image
data "aws_ecr_image" "service_image" {
  repository_name = var.docker_repository
  most_recent     = true
}

# ECS Cluster
resource "aws_ecs_cluster" "betterreads_cluster" {
  name = "betterreads-cluster"
}

# IAM role for the ECS task execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AmazonECSTaskExecutionRolePolicy to the role for pulling images and secrets
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Grant permission to access Secrets Manager
resource "aws_iam_role_policy" "ecs_secrets_policy" {
  name = "ecsSecretsPolicy"
  role = aws_iam_role.ecs_task_execution_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# Get Secret/s
data "aws_secretsmanager_secret" "book_api_secret" {
  name = "BOOK_API"
}

data "aws_secretsmanager_secret_version" "book_secret_version" {
  secret_id = data.aws_secretsmanager_secret.book_api_secret.id
}

data "aws_secretsmanager_secret" "db_key" {
  name = "DB_ACCESS_KEY"
}

data "aws_secretsmanager_secret_version" "db_key_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_key.id
}

data "aws_secretsmanager_secret" "db_secret_key" {
  name = "DB_SECRET_ACCESS_KEY"
}

data "aws_secretsmanager_secret_version" "db_secret_key_secret_version" {
  secret_id = data.aws_secretsmanager_secret.db_secret_key.id
}

# ECS Task
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family             = "my-ecs-task"
  network_mode       = "host"
  cpu                = 256
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  container_definitions = jsonencode([
    {
      name      = "dockergs"
      image     = data.aws_ecr_image.service_image.image_uri,
      cpu       = 256
      memory    = 512
      essential = true

      # Environment Variables
      "environment" = [
        {
          name  = "BOOK_API",
          value = jsondecode(data.aws_secretsmanager_secret_version.book_secret_version.secret_string)["BOOK_API"]
        },
        {
          name  = "DB_ACCESS_KEY",
          value = jsondecode(data.aws_secretsmanager_secret_version.db_key_secret_version.secret_string)["DB_ACCESS_KEY"]
        },
        {
          name  = "DB_SECRET_ACCESS_KEY",
          value = jsondecode(data.aws_secretsmanager_secret_version.db_secret_key_secret_version.secret_string)["DB_SECRET_ACCESS_KEY"]
        },
      ]

      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECS Capacity Provider
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name = "betterreads_capacity_provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.ecs_asg.arn

    managed_scaling {
      maximum_scaling_step_size = 1000
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 3
    }
  }
}

# ECS Cluster Capacity Provider
resource "aws_ecs_cluster_capacity_providers" "cluster_cp" {
  cluster_name       = aws_ecs_cluster.betterreads_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
  }
}

# Output service image name for debugging
output "docker-image" {
  value = data.aws_ecr_image.service_image.image_uri
}