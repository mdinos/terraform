output "marcus_nginx_tg_arn" {
  value = "${aws_lb_target_group.marcus_nginx_tg.arn}"
}
