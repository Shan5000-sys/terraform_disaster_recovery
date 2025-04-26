output "primary_instance_id" {
  value = module.primary_web.instance_id
}

output "secondary_instance_id" {
  value = module.secondary_web.instance_id
}

output "primary_vpc_id" {
  value = module.vpc_primary.vpc_id
}

output "secondary_vpc_id" {
  value = module.vpc_secondary.vpc_id
}

output "primary_elastic_ip" {
  value = module.primary_web.elastic_ip
}