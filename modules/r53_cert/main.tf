resource "aws_route53_zone" "a1_octarine" {
  name = var.octarine-domain

  tags = {
    "Env":"Prod"
  }
}

resource "aws_acm_certificate" "a1_octarine" {
  domain_name = var.octarine-domain
  subject_alternative_names = [
    "*.${var.octarine-domain}"
  ]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Env":"Prod"
  }
}

resource "aws_route53_record" "a1_octarine_validation" {
  for_each = {
    for dvo in aws_acm_certificate.a1_octarine.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.a1_octarine.id
}


resource "aws_acm_certificate_validation" "a1_octarine_validation" {
  certificate_arn = aws_acm_certificate.a1_octarine.arn
  validation_record_fqdns = [for record in aws_route53_record.a1_octarine_validation : record.fqdn]
}
