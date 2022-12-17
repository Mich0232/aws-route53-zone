output "id" {
  value = aws_route53_zone.main.id
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  value = var.no_certificate ? null : aws_acm_certificate_validation.main[1].certificate_arn
}
