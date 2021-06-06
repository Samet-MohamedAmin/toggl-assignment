resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "master" {
  name             = "${var.prefix}-db-instance-${random_id.db_name_suffix.hex}"
  region           = var.region
  database_version = var.postgres_version

  deletion_protection = false

  settings {
    tier = var.db_machine_type
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.backend_network.id
      authorized_networks {
        name  = "allow-all-inbound"
        value = "0.0.0.0/0"
        # https://cloud.google.com/sql/docs/postgres/authorize-networks#limitations
        // value = google_compute_subnetwork.backend_network_api_subnetwork.ip_cidr_range
      }
    }

    disk_size         = 10
    disk_type         = "PD_HDD"
    availability_type = "ZONAL"
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}

resource "google_sql_user" "default" {
  depends_on = [google_sql_database_instance.master]

  name     = var.master_user_name
  instance = google_sql_database_instance.master.name
  password = var.master_user_password
}

