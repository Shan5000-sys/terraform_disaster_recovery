resource "aws_route53_health_check" "primary_instance" {
  type              = "HTTP"
  port              = 80
  resource_path     = "/"
  failure_threshold = 3
  request_interval  = 30
ip_address = module.primary_web.elastic_ip

  tags = {
    Name = "Primary Instance Health Check"
  }
}