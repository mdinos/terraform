provider "google" {
  credentials = file("creds/terraform-sv-acc-creds.json")
  project     = var.project_id
  region      = var.region
}