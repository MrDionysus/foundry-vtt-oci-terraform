resource "oci_core_virtual_network" "foundry_network" {
  cidr_block     = "192.168.0.0/23"
  compartment_id = var.tenancy_ocid
  display_name   = "foundry"
}

resource "oci_core_subnet" "public_subnet" {
  cidr_block        = "192.168.0.0/24"
  compartment_id    = var.tenancy_ocid
  vcn_id            = oci_core_virtual_network.foundry_network.id
  display_name      = "foundrypublicsubnet"
  security_list_ids = [oci_core_security_list.foundry_security_list.id]
  route_table_id    = oci_core_route_table.foundry_route_table.id
  dhcp_options_id   = oci_core_virtual_network.foundry_network.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "foundry_internet_gateway" {
  compartment_id = var.tenancy_ocid
  display_name   = "foundryIG"
  vcn_id         = oci_core_virtual_network.foundry_network.id
}

resource "oci_core_route_table" "foundry_route_table" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_virtual_network.foundry_network.id
  display_name   = "foundryRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.foundry_internet_gateway.id
  }
}

resource "oci_core_security_list" "foundry_security_list" {
  compartment_id = var.tenancy_ocid
  vcn_id         = oci_core_virtual_network.foundry_network.id
  display_name   = "foundrySecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    stateless = true

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    stateless = true

    tcp_options {
      max = "80"
      min = "80"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    stateless = true

    tcp_options {
      max = "443"
      min = "443"
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    stateless = true

    tcp_options {
      max = "30000"
      min = "30000"
    }
  }
  
}