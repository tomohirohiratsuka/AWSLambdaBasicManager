#####################################################
## Primary Domain Data
#####################################################

data "aws_route53_zone" "domain" {
  name = var.domain_name
}

#####################################################
## Sub Domain
#####################################################
resource "aws_route53_zone" "subdomain" {
  name           = var.subdomain_name
}

#####################################################
## Sub Domain Certificate
#####################################################
resource "aws_acm_certificate" "subdomain" {
  domain_name       = aws_route53_zone.subdomain.name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "subdomain" {
  certificate_arn = aws_acm_certificate.subdomain.arn
}

resource "aws_route53_record" "api_ns_records" {
  name    = aws_route53_zone.subdomain.name
  type    = "NS"
  zone_id = data.aws_route53_zone.domain.id
  records = [
    aws_route53_zone.subdomain.name_servers[0],
    aws_route53_zone.subdomain.name_servers[1],
    aws_route53_zone.subdomain.name_servers[2],
    aws_route53_zone.subdomain.name_servers[3],
  ]
  ttl = 172800
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.subdomain.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.subdomain.zone_id
}

#####################################################
## Sub Domain Alias
#####################################################

resource "aws_route53_record" "api_alb_alias" {
  name    = aws_route53_zone.subdomain.name
  type    = "A"
  zone_id = aws_route53_zone.subdomain.zone_id
  alias {
    evaluate_target_health = true
    name                   = aws_lb.main.dns_name
    zone_id                = aws_lb.main.zone_id
  }
}
