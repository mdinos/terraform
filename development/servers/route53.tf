data "aws_route53_zone" "selected" {
  name         = "mdinos.net."
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = "${data.aws_route53_zone.selected.zone_id}"
  name    = "www.mdinos.net"
  type    = "A"

  alias {
    name                   = "${aws_lb.marcus_nginx_lb.dns_name}"
    zone_id                = "${aws_lb.marcus_nginx_lb.zone_id}"
    evaluate_target_health = true
  }
}