exports.handler = async (event) => {
    console.log("SNS alert received:", JSON.stringify(event, null, 2));
  };

  resource "aws_route53_health_check" "primary_instance" {
    depends_on        = [module.primary_web]
  
    type              = "HTTP"
    port              = 80
    resource_path     = "/"
    failure_threshold = 3
    request_interval  = 30
    ip_address        = module.primary_web.public_ip
  
    tags = {
      Name = "Primary Instance Health Check"
    }
  }
  
  resource "aws_eip" "elastic" {
    instance = aws_instance.web.id
    vpc      = true
  }