resource "aws_elasticache_serverless_cache" "db" {
  engine                    = "redis"
  name                      = "${var.app_name}-db"
  description               = "For bullets"
  major_engine_version      = "7"
  security_group_ids        = [aws_security_group.db.id]
  subnet_ids                = local.subnet_ids
}

resource "aws_security_group" "db" {
  name        = "${var.app_name}-db"
  description = "DB security group"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
