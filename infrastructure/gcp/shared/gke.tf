resource "google_container_cluster" "cluster" {
  name               = "jkm"
  location           = "us-central1"
  initial_node_count = 1

  enable_autopilot = true
  deletion_protection = false

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

output "cluster_endpoint" {
  description = "The IP address of the cluster master"
  value       = google_container_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  description = "The public certificate that is the root of trust for the cluster"
  value       = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
}