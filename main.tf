resource "aws_route53_zone" "main" {
  name = var.domain

  tags = local.resource_tags
}


/* Certificates */
resource "aws_acm_certificate" "main" {
  provider = aws.aws-na

  domain_name       = var.domain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "main" {
  provider = aws.aws-na

  certificate_arn         = aws_acm_certificate.main.arn
  validation_record_fqdns = [for record in aws_route53_record.main-certificate-validation : record.fqdn]
}

/* Records */
/* Main Domain Records */
resource "aws_route53_record" "main-certificate-validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = var.record_ttl
  type            = each.value.type
  zone_id         = aws_route53_zone.main.id
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.id
  name    = "www.${var.domain}"
  type    = "CNAME"
  ttl     = var.record_ttl
  records = [var.domain]
}

resource "aws_route53_record" "record" {
  for_each = var.records

  zone_id = aws_route53_zone.main.id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl
  records = each.value.records

  dynamic "alias" {
    for_each = each.value.alias != null ? [1] : []
    content {
      name                   = each.value.name
      zone_id                = each.value.zone_id
      evaluate_target_health = each.value.evaluate_target_health
    }
  }
}
