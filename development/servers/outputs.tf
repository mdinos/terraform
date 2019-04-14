output "marcus_nginx_tg_arn" {
  value = "${aws_lb_target_group.marcus_nginx_tg.arn}"
}

output "s3_bucket_id" {
  value = "${aws_s3_bucket.marcus-nginx-access-s3.id}"
}
