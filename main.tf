resource "aws_route53_zone" "main" {
  name = var.domain

  tags = local.resource_tags
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.id
  name    = "www.${var.domain}"
  type    = "CNAME"
  ttl     = var.default_ttl
  records = [var.domain]
}

resource "aws_route53_record" "record" {
  for_each = var.records

  zone_id = aws_route53_zone.main.id
  name    = each.value.name
  type    = each.value.type
  ttl     = each.value.ttl != null ? each.value.ttl : var.default_ttl
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
