resource "google_compute_network" "backend_network" {
  name                    = "${var.prefix}-backend-network"
  auto_create_subnetworks = false
}

resource "google_compute_global_address" "private_ip_address" {
  project       = var.project
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.backend_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.backend_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_compute_subnetwork" "backend_network_api_subnetwork" {
  name          = "${var.prefix}-backend-network-api-subnetwrok"
  region        = var.region
  network       = google_compute_network.backend_network.self_link
  ip_cidr_range = "10.1.0.0/16"
}

resource "google_compute_firewall" "rule_ingress" {
  name    = "${var.prefix}-firewall-allow-ingress"
  network = google_compute_network.backend_network.name

  direction = "INGRESS"

  allow {
    protocol = "all"
    ports    = []
  }
}

resource "google_compute_firewall" "rule_egress" {
  name    = "${var.prefix}-firewall-allow-egress"
  network = google_compute_network.backend_network.name

  direction = "EGRESS"

  allow {
    protocol = "all"
    ports    = []
  }

  depends_on = [google_compute_network.backend_network]
}
