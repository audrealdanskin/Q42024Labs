terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "2.6.0"
    }
  }
}

provider "equinix" {
  # Configuration options 
  # Credentials for only Equinix Metal resources 
  auth_token = "my_auth_token"

  client_id = "my_client_id"

  client_secret = "my_client_secret"
}


# Creates ACL template and assigns it to the network device

resource "equinix_network_acl_template" "myacl" {
  name        = "audreaq4acl"
  description = "myacl ACL template"
  project_id  = "my_project_id"
  inbound_rule {
    subnet   = "147.28.136.125/32"
    protocol = "IP"
    src_port = "any"
    dst_port = "any"
  }

  inbound_rule {
    subnet   = "172.28.224.153/32"
    protocol = "TCP"
    src_port = "any"
    dst_port = "any"
  }
}

# Create self configured single Catalyst 8000V (Autonomous Mode) router with license token

resource "equinix_network_device" "audrealabda" {
  name                 = "audrealabda"
  metro_code           = "DA"
  type_code            = "C8000V"
  self_managed         = true
  byol                 = true
  package_code         = "network-essentials"
  notifications        = ["adanskin@equinix.com"]
  hostname             = "audreaq4"
  account_number       = 1
  version              = "17.09.04a"
  core_count           = 2
  term_length          = 1
  additional_bandwidth = 5
  acl_template_id      = "my_acl_id"

  ssh_key {
    username = "audrea"
    key_name = "audreapublickey"
  }
}

resource "equinix_network_device" "audrealabdc" {
  name                 = "audrealabdc"
  metro_code           = "DC"
  type_code            = "C8000V"
  self_managed         = true
  byol                 = true
  package_code         = "network-essentials"
  notifications        = ["adanskin@equinix.com"]
  hostname             = "audreaq4dc"
  account_number       = 1
  version              = "17.09.04a"
  core_count           = 2
  term_length          = 1
  additional_bandwidth = 5
  acl_template_id      = "my_acl_id"

  ssh_key {
    username = "audrea"
    key_name = "audreapublickey"
  }
}
resource "equinix_network_device_link" "audreadlg" { 
name   = "test-link"
project_id  = "my_project_id"
device { 
id        = equinix_network_device.audrealabda.uuid
interface_id = 4
}
device {
id       = equinix_network_device.audrealabdc.uuid
interface_id = 4
}
link {
    account_number  =  1_gjhbe%6
    src_metro_code  = equinix_network_device.audrealabda.metro_code
    dst_metro_code  = equinix_network_device.audrealabdc.metro_code
    throughput      = "50"
    throughput_unit = "Mbps"
  }
}
