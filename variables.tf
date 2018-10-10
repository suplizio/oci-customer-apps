// Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.

variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_authorized_keys" {}
variable "display_name_prefix" {}

variable "image_ids" {
  type = "map"

  default = {
    // Oracle-provided image "Oracle-Linux-7.5"
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaasez4lk2lucxcm52nslj5nhkvbvjtfies4yopwoy4b3vysg5iwjra"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaajlw3xfie2t5t52uegyhiq2npx7bqyu4uvi2zyu3w3mqayc2bxmaa"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7d3fsb6272srnftyi4dphdgfjf6gurxqhmv6ileds7ba3m2gltxq"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaa6h6gj6v4n56mqrbgnosskq63blyv2752g36zerymy63cfkojiiq"
  }
}

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "backend_shape" {
  default = "VM.Standard1.1"
}

variable "assign_public_ip" {
  default = true
}

variable "display_name" {
  description = "The display name of the load balancer."
  default     = "demo_lb"
}

variable "shape" {
  description = "The shape of the load balancer."
  default     = "100Mbps"
}

variable "is_private" {
  description = "To create a public or private load balancer."
  default     = false
}

variable "backendset_name" {
  description = "The name of the backendset."
  default     = "demo_bs1"
}

variable "backendset_policy" {
  description = "The load balancer policy for the backend set."
  default     = "ROUND_ROBIN"
}

variable "hc_protocol" {
  description = "The health chheecker protocol."
  default     = "HTTP"
}

variable "hc_port" {
  description = "The backend server port against which to run the health check"
  default     = "80"
}

variable "hc_response_body_regex" {
  description = "A regular expression for parsing the response body from the backend server."
  default     = ".*"
}

variable "hc_url_path" {
  description = "A URL endpoint against which to run the health check."
  default     = "/"
}

variable "backend_count" {
  description = "The number of the backend servers."
  default     = 1
}

variable "backend_ports" {
  type = "list"
  description = "The communication port for the backend server."
  default     = ["80"]
}

variable "path_route_set_name" {
  description = "The name of the set of path-based routing rules."
  default     = "demo_prs1"
}

variable "path" {
  description = "The path string to match against the incoming URI path."
  default     = "/app"
}

variable "path_match_type" {
  description = "The type of matching to apply to incoming URIs."
  default     = "EXACT_MATCH"
}

variable "hostnames" {
  type = "list"
  description = "A list of virtual hostnames."
  default     = ["hostname1", "hostname2"]
}

variable "hostname_names" {
  type = "list"
  description = "A list of friendly name for the hostname resources."
  default = []
}

variable "listener_certificate_name" {
  description = "The friendly name of the SSL certificate for listener."
  default     = ""
}

variable "listener_ca_certificate" {
  description = "The associated Certificate Authority certificate."
  default     = ""
}

variable "listener_private_key" {
  description = "The private key for the certificate."
  default     = ""
}

variable "listener_public_certificate" {
  description = "The certificate in PEM format."
  default     = ""
}

variable "listener_protocol" {
  description = "The protocol on which the listener accepts connection requests, either HTTP or TCP."
  default     = "HTTP"
}

variable "ssl_listener_name" {
  description = "The name of the listener with ssl enabled."
  default     = ""
}

variable "ssl_listener_port" {
  description = "The communication port for the listener with ssl enabled."
  default     = "443"
}

variable "ssl_verify_peer_certificate" {
  description = "To enable peer certificate verification."
  default     = false
}

variable "ssl_verify_depth" {
  description = "The maximum depth for certificate chain verification."
  default     = 0
}

variable "ssl_listener_hostnames" {
  type = "list"
  description = "The hostname resources for the listener with ssl enabled."
  default     = []
}

variable "ssl_listener_path_route_set" {
  description = "The path route set name for the listener with ssl enabled. It applys only to HTTP and HTTPS requests."
  default     = "prs1"
}

variable "non_ssl_listener_name" {
  description = "The name of the listener without ssl enabled."
  default     = "non_ssl_listener"
}

variable "non_ssl_listener_port" {
  description = "The communication port for the listener without ssl enabled."
  default     = "80"
}

variable "non_ssl_listener_hostnames" {
  type = "list"
  description = "The hostname resources for the listener without ssl enabled."
  default     = []
}

variable "non_ssl_listener_path_route_set" {
  description = "The path route set name for the listener without ssl enabled. It applys only to HTTP and HTTPS requests."
  default     = ""
}

variable "bootstrap_file" {
  default = "./userdata/bootstrap"
}

#### Ansible files #####
variable ansible_files_dir {
  description = "The name of the directory containing the generated yml file/s."
  default = "ansible"
}

variable ansible_hosts_filename {
  description = "The name of the Ansible yml file containing the hosts information."
  default = "hosts.yml"
}

variable hosts_tpl_filename {
  description = "The name of the terrafor Terraform template file used to create the Ansible hosts file."
  default = "hosts.yml.tpl"
}