resource "aws_ssm_parameter" "db_endpoint" {
  name  = "/${var.app_name}/db/endpoint"
  type  = "String"
  value = aws_elasticache_serverless_cache.db.endpoint[0]
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.app_name}/db/password"
  type  = "String"
  value = "no-password"
}

resource "aws_ssm_parameter" "lb_address_parameter" {
  name  = "/${var.app_name}/lb/address"
  type  = "String"
  value = aws_lb.lb.dns_name
}

resource "aws_iam_policy" "parameter_store_policy" {
  name        = "${var.app_name}_parameter_store_policy"
  description = "Policy to allow access to SSM parameter store"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "ssm:DescribeParameters",
          "ssm:DescribeParameter",
          "kms:Decrypt"
        ],
        Resource = "arn:aws:ssm:${var.aws_region}:${var.aws_account}:parameter/${var.app_name}/*"
      }
    ]
  })
}
