resource "aws_route53_zone" "kw_zone" {
  name = var.domain

  tags = merge(tomap(
  {Name = "kw_route53_zone"}),
    var.mypage-tags
)
}

resource "aws_acm_certificate" "kw_cert" {
  domain_name = var.domain
  subject_alternative_names = [
    "*.${var.domain}"
  ]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(tomap(
  {Name = "kw_cert"}),
    var.mypage-tags
)
}

resource "aws_route53_record" "mypage_validation" {
  for_each = {
    for dvo in aws_acm_certificate.kw_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 300
  type            = each.value.type
  zone_id         = aws_route53_zone.kw_zone.id
}


resource "aws_acm_certificate_validation" "kw_validation" {
  certificate_arn = aws_acm_certificate.kw_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.mypage_validation : record.fqdn]
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.kw_zone.zone_id
  name    = "kulikov.work"
  type    = "A"

  alias {
    name                   = var.lbdns_name
    zone_id                = var.lbzone_id
    evaluate_target_health = true
  }
}
