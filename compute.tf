resource "oci_core_instance" "foundry_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.tenancy_ocid
  display_name        = "foundry_instance"
  shape               = var.compute_shape

  shape_config {
    ocpus               = var.ocpus
    memory_in_gbs       = var.memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = oci_core_subnet.public_subnet.id
    display_name     = "primaryvnic"
    assign_public_ip = true
    assign_private_dns_record = false
  }

  source_details {
    source_type = "image"
    source_id   = var.image_id
    boot_volume_size_in_gbs = var.instance_source_details_boot_volume_size_in_gbs
  }

  metadata = {
    ssh_authorized_keys = file("${var.ssh_public_key_path}")
  }
}
