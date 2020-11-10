output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "subnet1_name" {
  value = google_compute_subnetwork.subnet_1.name
}