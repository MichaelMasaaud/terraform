provider "google" {
  project    = "sharp-nation-214017"
  credentials = "${file("/tmp/account.json")}"
}

resource "google_compute_router" "router1" {
  name    = "ic-router"
  network = "${google_compute_network.network1.name}"
  bgp {
    asn               = 64514
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
    advertised_ip_ranges {
      range = "1.2.3.4"
    }
    advertised_ip_ranges {
      range = "6.7.0.0/16"
    }
  }
}
resource "google_compute_interconnect_attachment" "on_prem" {
  name         = "on-prem-attachment-1"
  interconnect = "my-interconnect-id"
  router       = "${google_compute_router.router1.self_link}"
}

resource "google_compute_network" "network1" {
  name = "default"
  auto_create_subnetworks = false
}

