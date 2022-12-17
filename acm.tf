locals {
  certificate_arn           = local.create_certificate ? aws_acm_certificate.main[1].arn : var.certificate.arn
  domain_validation_options = var.no_certificate ? [] : local.create_certificate ? aws_acm_certificate.main[1].domain_validation_options : var.certificate.domain_validation_options
}

resource "aws_acm_certificate" "main" {
  for_each = local.create_certificate && var.no_certificate == false ? [1] : []

  provider = aws.aws-na

  domain_name       = var.domain
  validation_method = "DNS"

  tags = local.resource_tags

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_route53_zone.main]
}

resource "aws_acm_certificate_validation" "main" {
  for_each = length(local.domain_validation_options) > 0 ? [1] : []
  provider = aws.aws-na

  certificate_arn         = local.certificate_arn
  validation_record_fqdns = [for record in aws_route53_record.main-certificate-validation : record.fqdn]

  depends_on = [aws_route53_record.main-certificate-validation]
}

resource "aws_route53_record" "main-certificate-validation" {
  for_each = {
    for dvo in local.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.default_ttl
  type            = each.value.type
  zone_id         = aws_route53_zone.main.id
}
