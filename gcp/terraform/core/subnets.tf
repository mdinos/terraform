resource "google_compute_subnetwork" "subnet_1" {
  name                     = "${var.project_id}-subnet1"
  region                   = var.region
  network                  = google_compute_network.vpc.name
  ip_cidr_range            = "10.1.0.0/24"
  private_ip_google_access = true
}