output "alb_dns_name" {

  description = "Application URL"
  value       = aws_lb.app_alb.dns_name
}
