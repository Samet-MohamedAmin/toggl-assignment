output "load_balancer_ip_address" {
  description = "IP address of the Cloud Load Balancer"
  value       = google_compute_global_address.default.address
}

output "sql_ip_address" {
  value = google_sql_database_instance.master.private_ip_address
}
