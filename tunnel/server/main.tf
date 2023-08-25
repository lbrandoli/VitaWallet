provider "google" {
  credentials = var.credential
  project     = var.project_id
  region      = var.region
}

data "google_compute_vpn_gateway" "vpn_gateway_server" {
  name = "vpn-gateway-server"
  region = var.region
}

data "google_compute_network" "vpn_network_server" {
  name = "vpn-network-server"
}

resource "google_compute_vpn_tunnel" "vpn_tunnel_server" {
  name          = "vpn-tunnel-server"
  peer_ip       = var.ip_client
  shared_secret = var.shared_secret
  target_vpn_gateway = data.google_compute_vpn_gateway.vpn_gateway_server.id
  local_traffic_selector = ["0.0.0.0/0"]
  remote_traffic_selector = ["0.0.0.0/0"]
}

resource "google_compute_route" "route_server" {
  name       = "route-server"
  network    = data.google_compute_network.vpn_network_server.name
  dest_range = var.ip_client_range

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel_server.id
}