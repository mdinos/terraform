resource "google_container_cluster" "primary_cluster" {
  name                     = "${var.project_id}-primary-cluster"
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.vpc_name
  subnetwork               = var.subnet_name
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "primary-preempt-node-pool"
  location   = var.region
  cluster    = google_container_cluster.primary_cluster.name
  node_count = 1

  autoscaling {
      min_node_count = 1
      max_node_count = 2
  }

  node_config {
    preemptible  = true
    machine_type = "e2-micro"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only"
    ]
  }
}