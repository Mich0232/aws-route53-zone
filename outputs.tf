output "id" {
  value = aws_route53_zone.main.id
}

output "name_servers" {
  value = aws_route53_zone.main.name_servers
}

output "certificate_arn" {
  value = aws_acm_certificate_validation.main.certificate_arn
}
