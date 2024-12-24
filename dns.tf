data "aws_route53_zone" "public" {
  name         = "triconlabs.com"
  private_zone = false
}

resource "aws_route53_record" "python-app" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "display"
  type    = "CNAME"
  ttl     = 300
  records = [""]
}