resource "google_compute_instance" "gce_vm" {
  name         = var.machine_name
  machine_type = var.machine_type
  zone         = var.machine_zone
  description  = var.description
  allow_stopping_for_update = true
  deletion_protection       = var.vm_deletion_protection
  tags = var.network_tags
  boot_disk {
    auto_delete = var.auto_delete
    source      = google_compute_disk.boot_gce_disk.id
  }
  metadata = merge({
    block-project-ssh-keys = "true"
    },
    var.metadata
  )
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    network_ip = var.static_internal_ip_address != null ? var.static_internal_ip_address : null
  }
  service_account {
    email  = "${var.service_account_name}@${var.project_id}.iam.gserviceaccount.com"
    scopes = var.scopes
  }
  labels = var.instance_labels
}