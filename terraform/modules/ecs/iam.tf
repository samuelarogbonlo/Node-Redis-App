# IAM policies 
resource "aws_iam_policy" "lifinance-policy" {
  name = "lifinance-policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
      Effect = "Allow",
      Action = [
        "elb:*",
      ],
      Resource = "*"
    }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs-iam-policy-attachment" {
  role       = aws_iam_role.lifinance-role.name
  policy_arn = aws_iam_policy.lifinance-policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.lifinance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "rds_access_policy" {
  name   = "rds-access-policy"
  policy = file("rds-access.json")
}

resource "aws_iam_role_policy_attachment" "rds_policy_attachment" {
  role       = aws_iam_role.lifinance-role.name
  policy_arn = aws_iam_policy.rds_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "redis_policy_attachment" {
  role       = aws_iam_role.lifinance-role.name
  policy_arn = aws_iam_policy.ssm_parameter_policy.arn
}

resource "aws_iam_role_policy_attachment" "redis_secret_policy_attachment" {
  role       = aws_iam_role.lifinance-role.name
  policy_arn = aws_iam_policy.secret_manager_policy.arn
}

#Create a policy to read from the specific parameter store
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "ssm_parameter_policy" {
  name        = "node-app-ssm-parameter-read-policy"
  path        = "/"
  description = "Policy to read the ElastiCache endpoint and port number stored in the SSM Parameter Store."
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        Resource = [var.redis_port_arn, var.redis_string_url_arn, var.posgress_endpoint_arn]
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ]
        Resource = [var.kms_rest]
      }
    ]
  })
}

#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy
resource "aws_iam_policy" "secret_manager_policy" {
  name        = "node-app-secret-read-policy"
  path        = "/"
  description = "Policy to read the ElastiCache AUTH Token stored in AWS Secrets Manager secret."
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [var.redis_auth_arn, var.posgress_password_arn]
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt"
        ]
        Resource = [var.kms_secret]
      }
    ]
  })
}

resource "aws_iam_role" "lifinance-role" {
  name = "lifinance-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}
