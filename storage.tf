module "storage" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 5.0"

  name       = "${var.project_id}-storage"
  project_id = var.project_id

  location = "eu"

  autoclass = true
}
