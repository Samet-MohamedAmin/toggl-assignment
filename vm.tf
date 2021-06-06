resource "google_compute_instance_template" "compute" {
  name_prefix = "${var.prefix}-instance-template"

  machine_type = "e2-medium"

  region = var.region

  tags = [
    "allow-ssh",
    "allow-service",
    "http-server",
    "https-server"
  ]

  network_interface {
    network    = google_compute_network.backend_network.name
    subnetwork = google_compute_subnetwork.backend_network_api_subnetwork.name
    access_config {
      network_tier = "PREMIUM"
    }
  }

  disk {
    source_image = "centos-cloud/centos-8"
    auto_delete  = true
    disk_size_gb = 20
    boot         = true
  }

  metadata_startup_script = templatefile("script.sh.tpl",
    {
      port                 = 80
      master_user_password = var.master_user_password
      master_user_name     = var.master_user_name
      sql_ip_address       = google_sql_database_instance.master.private_ip_address
      bucket_name          = google_storage_bucket.static_samet_bucket.name
  })

  metadata = {
    ssh-keys = "MohamedAmin:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDU/nhbXeQNWia6lSDRw241HwOGfQxXKrHnp9w7002Xf4rdNUHTxsjlDXRKHPSdL9mxh6z52DLy2OHFAcGbrewZfUaU2FlOCD2sqPFVOvwX3BKpXcxZmL48sFoHfZTjUlYCoeCNtPAO0vFIuv69qlJWZ1KegWmH4N5kViduTgRFqmuume8rnhtbdzGO+57NfhMemGPafxWV0+w+wO3E6za+xUmdl4hNvP1l9KoN/+T/Od0PzFemamXoGYew9lmQxtcge9utB5dNRaE8JDvqHDfou3j3ie+6pNEy68Rrx0qRuCbvEt0dFa4+1QDZvEOKY+Mj7PzxFCBC2BXYxiwdIw3l8JPlPEk5fxeYAxYQOSGzGu8PlJtFBz/ydiLrnFAW2hjpNi8/eVDpS/KbGhynhNkyBB3GlaGlk/OxOQwKLwdgPaOp30Nx4CTUKEKgZc5BBwg5t3cDA2VRKFX59vHfhrkLj9mjorplXZUKQtZPfqxpZrnlFqST2LtuKnxI+kwSbzE= MohamedAmin@samet"
  }

  depends_on = [google_sql_database_instance.master, google_compute_network.backend_network, google_compute_subnetwork.backend_network_api_subnetwork]
}

resource "google_compute_instance_group_manager" "compute" {
  name        = "${var.prefix}-mig-compute"
  description = "compute VM Instance Group"

  base_instance_name = "${var.prefix}-compute-instance"

  version {
    instance_template = google_compute_instance_template.compute.self_link
  }

  zone = var.zone

  target_size = 1

  named_port {
    name = "http"
    port = 80
  }

  depends_on = [google_compute_instance_template.compute]
}

resource "google_compute_backend_service" "compute" {
  name = "${var.prefix}-api-server-backend"

  port_name = "http"
  protocol  = "HTTP"

  backend {
    group = google_compute_instance_group_manager.compute.instance_group
  }
  health_checks = [
    google_compute_http_health_check.api_server_health.id,
  ]

  depends_on = [google_compute_instance_group_manager.compute, google_compute_http_health_check.api_server_health]
}

resource "google_compute_http_health_check" "api_server_health" {
  name         = "api-server-health"
  port         = 80
  request_path = "/api/status"
}