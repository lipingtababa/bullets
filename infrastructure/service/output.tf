output "alb_address" {
  value = aws_lb.lb.dns_name
}

output "service_name" {
  value = aws_ecs_service.the_ecs_service.name
}

output "db_address" {
  value = aws_elasticache_serverless_cache.db.endpoint
}
