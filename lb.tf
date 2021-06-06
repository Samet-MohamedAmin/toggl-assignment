resource "google_compute_url_map" "urlmap" {
  project = var.project

  name        = "${var.prefix}-url-map-2"
  description = "URL map for ${var.prefix}"

  default_service = google_compute_backend_bucket.static_samet_bucket.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "all"
  }

  path_matcher {
    name            = "all"
    default_service = google_compute_backend_bucket.static_samet_bucket.self_link

    path_rule {
      paths   = ["/api/*"]
      service = google_compute_backend_service.compute.self_link
    }
  }
}

resource "google_compute_global_address" "default" {
  project      = var.project
  name         = "${var.prefix}-address"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

resource "google_compute_target_http_proxy" "http" {
  project = var.project
  name    = "${var.prefix}-http-proxy"
  url_map = google_compute_url_map.urlmap.self_link

  depends_on = [google_compute_url_map.urlmap]
  // ssl_certificates = [google_compute_ssl_certificate.example.self_link]
}

resource "google_compute_global_forwarding_rule" "http" {
  project    = var.project
  name       = "${var.prefix}-http-rule"
  target     = google_compute_target_http_proxy.http.self_link
  ip_address = google_compute_global_address.default.address
  port_range = "80"

  depends_on = [google_compute_global_address.default, google_compute_target_http_proxy.http]
}

// resource "tls_private_key" "example" {
//   algorithm = "RSA"
//   rsa_bits  = 2048
// }

// resource "tls_self_signed_cert" "example" {
//   key_algorithm   = tls_private_key.example.algorithm
//   private_key_pem = tls_private_key.example.private_key_pem

//   # Certificate expires after 12 hours.
//   validity_period_hours = 12

//   # Generate a new certificate if Terraform is run within three
//   # hours of the certificate's expiration time.
//   early_renewal_hours = 3

//   # Reasonable set of uses for a server SSL certificate.
//   allowed_uses = [
//     "key_encipherment",
//     "digital_signature",
//     "server_auth",
//   ]

//   dns_names = [google_dns_record_set.dns_record_set.name]

//   subject {
//     common_name  = "samet_name"
//     organization = "ACME Examples, Inc"
//   }
// }

// resource "google_compute_ssl_certificate" "example" {
//   name        = "${var.prefix}-cert-example"
//   private_key = tls_private_key.example.private_key_pem
//   certificate = tls_self_signed_cert.example.cert_pem
// }


// resource "google_dns_managed_zone" "dns_parent_zone" {
//   name        = "myzone"
//   dns_name    = "myzone.samet.com."
//   description = "Test Description"
// }

// resource "google_dns_record_set" "dns_record_set" {
//   managed_zone = google_dns_managed_zone.dns_parent_zone.name
//   name         = "test-record.myzone.samet.com."
//   type         = "A"
//   rrdatas = [google_compute_global_address.default.address]
// }