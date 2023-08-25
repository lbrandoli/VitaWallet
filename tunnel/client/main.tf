provider "google" {
  credentials = var.credential
  project     = var.project_id
  region      = var.region
}

data "google_compute_vpn_gateway" "vpn_gateway_client" {
  name = "vpn-gateway-client"
  region = var.region
}

data "google_compute_network" "vpn_network_client" {
  name = "vpn-network-client"
}

resource "google_compute_vpn_tunnel" "vpn_tunnel_client" {
  name          = "vpn-tunnel-client"
  peer_ip       = var.ip_server // Public IP of the other server
  shared_secret = var.shared_secret
  target_vpn_gateway = data.google_compute_vpn_gateway.vpn_gateway_client.id
  local_traffic_selector = ["0.0.0.0/0"]
  remote_traffic_selector = ["0.0.0.0/0"]
}

resource "google_compute_route" "route_client" {
  name       = "route-client"
  network    = data.google_compute_network.vpn_network_client.name
  dest_range = var.ip_server_range

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.vpn_tunnel_client.id
}