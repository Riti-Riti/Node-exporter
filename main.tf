########################################
# EXECUTION ROLE (ECR + LOGS)
########################################
resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.task_family}-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

########################################
# TASK ROLE (APP PERMISSIONS)
########################################
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.task_family}-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}


########################################
# ECS TASK DEFINITION
########################################
resource "aws_ecs_task_definition" "node_exporter" {
  family                   = var.task_family
  network_mode             = "host"
  requires_compatibilities = ["EC2"]

  memory = var.memory

  # Separate roles (best practice)
  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.container_image
      essential = true

      cpu               = 0
      memoryReservation = var.memory_reservation

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.host_port
          protocol      = "tcp"
        }
      ]

      environment = []

      mountPoints = [
        {
          sourceVolume  = "proc"
          containerPath = "/host/proc"
        },
        {
          sourceVolume  = "sys"
          containerPath = "/host/sys"
        }
      ]

      volumesFrom    = []
      dockerLabels   = {}
      systemControls = []

      command = [
        "--path.procfs=/host/proc",
        "--path.sysfs=/host/sys"
      ]
    }
  ])

  volume {
    name = "proc"
    host_path = var.proc_path
  }

  volume {
    name = "sys"
    host_path = var.sys_path
  }

  tags = var.tags
}
