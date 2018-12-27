// Locals variables : Module logic
locals {
  iam_permissions = "${compact(split(",", data.external.flatten.result["output"]))}"
}

// Provides information on GCP provider config
data "google_client_config" "default" {}

// Flattens IAM Permissions for consumption via google_storage_bucket_iam_binding
data "external" "flatten" {
  program = ["docker", "run", "muvaki/terraform-flatten:0.0.1", "${jsonencode(var.iam)}"]
}

# Provisions a bucket
# Buckets can also be destroyed if force_destroy is set to true (useful for teardowns)
resource "google_storage_bucket" "default" {
  name          = "${var.name}"
  force_destroy = "${var.force_destroy}"
  location      = "${length(var.location) > 0 ? var.location : data.google_client_config.default.region}"
  project       = "${length(var.project) > 0 ? var.project : data.google_client_config.default.project}"
  storage_class = "${var.storage_class}"

  versioning {
    enabled = "${var.versioning_enabled}"
  }

  labels = "${var.labels}"
}

# Bucket level IAM role binding - Authoritative for given role
resource "google_storage_bucket_iam_binding" "default" {
    count     = "${length(local.iam_permissions) > 0 ? length(local.iam_permissions) : 0}"

    bucket = "${google_storage_bucket.default.name}"
    role   = "${trimspace(element(split("|", local.iam_permissions[count.index]), 0))}"

    members   = [
      "${compact(split(" ", element(split("|", local.iam_permissions[count.index]), 1)))}"
    ]
    
    depends_on = ["google_storage_bucket.default"]
}