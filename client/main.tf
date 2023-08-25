provider "google" {
  credentials = var.credential
  project     = var.project_id
  region      = var.region
}

#-----------------------------------------------------------------#
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#

resource "google_compute_network" "vpn_network_client" {
  name = "vpn-network-client"
}

resource "google_compute_subnetwork" "vpn_subnet_client" {
  name          = "vpn-subnet-client"
  network       = google_compute_network.vpn_network_client.id
  ip_cidr_range = var.ip_client_range
  region        = var.region
}

resource "google_compute_firewall" "vpn_firewall_client" {
  name    = "vpn-firewall-client"
  network = google_compute_network.vpn_network_client.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
    #ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "ip_client_internal" {
  name         = "ip-client-internal"
  subnetwork   = google_compute_subnetwork.vpn_subnet_client.id
  address_type = "INTERNAL"
  address      = var.ip_client
  region       = var.region
}

resource "google_compute_instance" "client" {
  name         = "client"
  machine_type = "n2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpn_network_client.id
    subnetwork = google_compute_subnetwork.vpn_subnet_client.id
    network_ip = var.ip_client
    access_config {}
  }

  depends_on = [ 
    google_compute_address.ip_client_internal,
   ]
}

resource "google_compute_vpn_gateway" "vpn_gateway_client" {
  name    = "vpn-gateway-client"
  network = google_compute_network.vpn_network_client.id
}

resource "google_compute_address" "ip_client_external" {
  name = "ip-client-external"
}

resource "google_compute_forwarding_rule" "fr_rule_client" {
  name        = "fr-rule-client"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.ip_client_external.address
  target      = google_compute_vpn_gateway.vpn_gateway_client.id
}

resource "google_compute_forwarding_rule" "fr_udp500_rule_client" {
  name        = "fr-udp500-rule-client"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.ip_client_external.address
  target      = google_compute_vpn_gateway.vpn_gateway_client.id
}

resource "google_compute_forwarding_rule" "fr_udp4500_rule_client" {
  name        = "fr-udp4500-rule-client"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.ip_client_external.address
  target      = google_compute_vpn_gateway.vpn_gateway_client.id
}

#---------------------------------------------------------------------#
#---------------------------------------------------------------------#
#---------------------------------------------------------------------#
#---------------------------------------------------------------------#







#---------------------------------------------------------------------#
#---------------------------------------------------------------------#
#---------------------------------------------------------------------#
#---------------------------------------------------------------------#

