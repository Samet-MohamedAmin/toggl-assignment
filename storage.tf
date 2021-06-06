resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# public bucket
resource "google_storage_bucket" "static_samet_bucket" {
  name     = "static_samet_bucket-${random_id.bucket_suffix.hex}"
  location = var.region
}

resource "google_compute_backend_bucket" "static_samet_bucket" {
  name        = "static-samet-bucket"
  bucket_name = google_storage_bucket.static_samet_bucket.name
  enable_cdn  = true
}

resource "google_storage_default_object_acl" "static_acl" {
  bucket      = google_storage_bucket.static_samet_bucket.name
  role_entity = ["READER:allUsers"]
}

resource "google_storage_bucket_object" "static_files" {
  for_each = fileset(path.module, "static/*")

  name       = basename(each.key)
  bucket     = google_storage_bucket.static_samet_bucket.name
  source     = each.key
  depends_on = [google_storage_default_object_acl.static_acl]
}
