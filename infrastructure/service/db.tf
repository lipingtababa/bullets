resource "aws_elasticache_serverless_cache" "db" {
  engine                    = "redis"
  name                      = "${var.app_name}-db"
  description               = "For bullets"
  major_engine_version      = "7"
  security_group_ids        = [aws_security_group.db.id]
  subnet_ids                = local.subnet_ids
  user_group_id            = aws_elasticache_user_group.db_users.id
}

resource "aws_elasticache_user" "user" {
  user_id       = "${var.app_name}-db-user"
  user_name     = "${var.app_name}"
  access_string = "on ~app::* +@all"
  engine        = "redis"
  passwords     = random_password.password.result
}

resource "aws_elasticache_user_group" "db_users" {
  user_group_id = "${var.app_name}-db-users"
  user_ids      = [aws_elasticache_user.user.user_id]
  engine        = "redis"
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
