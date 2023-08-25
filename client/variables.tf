variable "credential" {
  default = "gcp-client-credential.json"
}

variable "project_id" {
  default = "vitawallet"
}

variable "region" {
  default = "southamerica-west1"
}

variable "zone" {
  default = "southamerica-west1-a"
}

variable "shared_secret" {
  default = "VitaWallet"
}

variable "ip_server_range" {
  default = "10.5.5.0/24"
}

variable "ip_client_range" {
  default = "10.7.7.0/24"
}

variable "ip_server" {
  default = "10.5.5.2"
}

variable "ip_client" {
  default = "10.7.7.3"
}