data "template_file" "startup" {
  template = file(format("%s/startup.sh.tpl", path.module))
}

module "router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"

  name = "router"

  project = var.project_id

  network = module.network.network_name

  region = var.region

  nats = [{
    name                               = "gateway"
    source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
    subnetworks = [
      {
        name                     = module.network.subnets["${var.region}/private"].id
        source_ip_ranges_to_nat  = ["PRIMARY_IP_RANGE"]
      }
    ]
  }]
}

module "web_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 7.9"

  project_id = var.project_id

  machine_type = "e2-micro"

  network    = module.network.network_self_link
  subnetwork = module.network.subnets["${var.region}/private"].self_link

  name_prefix = "web-group"

  startup_script = data.template_file.startup.rendered

  source_image_family  = "ubuntu-2204-lts"
  source_image_project = "ubuntu-os-cloud"

  service_account = {
    email  = ""
    scopes = ["cloud-platform"]
  }

  tags = [
    "web-group"
  ]
}

module "web_group" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "~> 7.9"

  project_id = var.project_id

  region = var.region

  instance_template = module.web_template.self_link

  hostname = "web-group"

  named_ports = [{
    name = "http",
    port = 80
  }]

  autoscaling_enabled = true
  min_replicas        = var.web_min_replicas
  max_replicas        = var.web_max_replicas
}

module "web_lb" {
  source  = "terraform-google-modules/lb-http/google"
  version = "~> 10.0"

  name = "web-lb"

  project = var.project_id

  target_tags = ["web-group"]

  firewall_networks = [module.network.network_name]

  backends = {
    default = {
      protocol    = "HTTP"
      port        = 80
      port_name   = "http"
      timeout_sec = 10
      enable_cdn  = false

      health_check = {
        request_path = "/"
        port         = 80
      }

      log_config = {
        enable = false
      }

      groups = [
        {
          group = module.web_group.instance_group
        }
      ]

      iap_config = {
        enable = false
      }
    }
  }
}
