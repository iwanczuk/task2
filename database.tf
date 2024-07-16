module "psa" {
  source  = "terraform-google-modules/sql-db/google//modules/private_service_access"
  version = "~> 20.0"

  project_id  = var.project_id
  vpc_network = module.network.network_name

  depends_on = [module.network]
}

module "database" {
  source  = "terraform-google-modules/sql-db/google//modules/safer_mysql"
  version = "~> 18.0"

  name       = var.database_name
  project_id = var.project_id

  deletion_protection = false

  database_version = "MYSQL_8_0"

  region         = var.region
  zone           = var.database_primary_zone
  secondary_zone = var.database_secondary_zone

  tier = var.database_tier

  vpc_network        = module.network.network_self_link
  allocated_ip_range = module.psa.google_compute_global_address_name

  module_depends_on = [module.psa.peering_completed]
}
