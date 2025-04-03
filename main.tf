provider "google" {
  project = "devops-study-25"
  region  = "europe-west1"
  
}
resource "google_compute_network" "default" {
    name = "cure1-network"
}

resource "google_compute_firewall" "default" {
    name    = "default-allow-ssh"
    network = google_compute_network.default.name

    allow {
        protocol = "tcp"
        ports    = ["22"]
    }

    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm" {
  name         = "vm-instance"
  machine_type = "e2-micro"
  zone         = "europe-west1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = file("startup.sh")
}

output "instance_ip" {
  value = gcp_compute_instance.vm.network_interface[0].access_config[0].nat_ip
}