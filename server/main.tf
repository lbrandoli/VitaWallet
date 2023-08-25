provider "google" {
  credentials = var.credential
  project     = var.project_id
  region      = var.region
}



#-----------------------------------------------------------------#
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#
#-----------------------------------------------------------------#

resource "google_compute_network" "vpn_network_server" {
  name = "vpn-network-server"
}

resource "google_compute_subnetwork" "vpn_subnet_server" {
  name          = "vpn-subnet-server"
  network       = google_compute_network.vpn_network_server.id
  ip_cidr_range = var.ip_server_range
  region        = var.region
}

resource "google_compute_firewall" "vpn_firewall_server" {
  name    = "vpn-firewall-server"
  network = google_compute_network.vpn_network_server.name

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

resource "google_compute_address" "ip_server_internal" {
  name         = "ip-server-internal"
  subnetwork   = google_compute_subnetwork.vpn_subnet_server.id
  address_type = "INTERNAL"
  address      = var.ip_server
  region       = var.region
}

resource "google_compute_instance" "server" {
  name         = "server"
  machine_type = "n2-standard-2"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpn_network_server.id
    subnetwork = google_compute_subnetwork.vpn_subnet_server.id
    network_ip = var.ip_server
    access_config {}
  }

  depends_on = [ 
    google_compute_address.ip_server_internal,
   ]
}

resource "google_compute_vpn_gateway" "vpn_gateway_server" {
  name    = "vpn-gateway-server"
  network = google_compute_network.vpn_network_server.id
}

resource "google_compute_address" "ip_server_external" {
  name = "ip-server-external"
}

resource "google_compute_forwarding_rule" "fr_rule_server" {
  name        = "fr-rule-server"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.ip_server_external.address
  target      = google_compute_vpn_gateway.vpn_gateway_server.id
}

resource "google_compute_forwarding_rule" "fr_udp500_rule_server" {
  name        = "fr-udp500-rule-server"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.ip_server_external.address
  target      = google_compute_vpn_gateway.vpn_gateway_server.id
}

resource "google_compute_forwarding_rule" "fr_udp4500_rule_server" {
  name        = "fr-udp4500-rule-server"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.ip_server_external.address
  target      = google_compute_vpn_gateway.vpn_gateway_server.id
}