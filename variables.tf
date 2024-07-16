variable "project_id" {
  description = "The project ID to host the network in"
}

variable "region" {
  type        = string
  description = "The region name"
  default     = "europe-central2"
}

variable "network_name" {
  type        = string
  description = "The network name"
  default     = "task2"
}

variable "database_name" {
  type        = string
  description = "The database name"
  default     = "task2"
}

variable "database_primary_zone" {
  type        = string
  description = "The database primary zone name"
  default     = "europe-central2-a"
}

variable "database_secondary_zone" {
  type        = string
  description = "The database secondary zone name"
  default     = "europe-central2-b"
}

variable "database_tier" {
  type        = string
  description = "The database tier name"
  default     = "db-f1-micro"
}

variable "web_min_replicas" {
  type        = number
  description = "web_min_replicas"
  default     = 1
}

variable "web_max_replicas" {
  type        = number
  description = "web_min_replicas"
  default     = 2
}
