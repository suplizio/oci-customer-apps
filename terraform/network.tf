// Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.

provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

data "oci_identity_availability_domains" "ad" {
  compartment_id = "${var.tenancy_ocid}"
}

resource "oci_core_virtual_network" "lb" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.display_name_prefix}_vcn"
  cidr_block = "${var.vcn_cidr}"
  dns_label = "codeOneVcn"
}

resource "oci_core_internet_gateway" "lb" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.lb.id}"
  display_name = "${var.display_name_prefix}_igw"
}

resource "oci_core_route_table" "lb" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.lb.id}"
  display_name = "${var.display_name_prefix}_rt"

  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.lb.id}"
  }
}

locals {
  tcp_protocol = "6"
  all_protocol = "all"
  anywhere = "0.0.0.0/0"
  dmz_tier_prefix = "${cidrsubnet(var.vcn_cidr, 4, 0)}"
  app_tier_prefix = "${cidrsubnet(var.vcn_cidr, 4, 1)}"
  lb_subnet_prefix = "${cidrsubnet("${local.dmz_tier_prefix}", 4, 0)}"
  bs_subnet_prefix = "${cidrsubnet("${local.app_tier_prefix}", 4, 1)}"
  lb_subnet_count = "${var.is_private ? 1 : 2}"
  lb_sec_list_ids = [
    "${oci_core_security_list.lb.id}",
    "${element(concat(oci_core_security_list.non_ssl.*.id, list("")), 0)}"]
}

resource "oci_core_security_list" "lb" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.display_name_prefix}_secList"
  vcn_id = "${oci_core_virtual_network.lb.id}"

  egress_security_rules = [
    {
      protocol = "${local.all_protocol}"
      destination = "${local.anywhere}"
    }]

  ingress_security_rules = [
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.anywhere}"

      tcp_options {
        "min" = 80
        "max" = 80
      }
    },
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.anywhere}"

      tcp_options {
        "min" = 443
        "max" = 443
      }
    },
  ]
}

resource "oci_core_security_list" "non_ssl" {
  count = "${var.non_ssl_listener_port != "" ? 1 : 0}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.display_name_prefix}_non_ssl"
  vcn_id = "${oci_core_virtual_network.lb.id}"

  ingress_security_rules = [
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.anywhere}"

      tcp_options {
        "min" = "${var.non_ssl_listener_port}"
        "max" = "${var.non_ssl_listener_port}"
      }
    }]
}

resource "oci_core_security_list" "bs" {
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.display_name_prefix}_bs_secList"
  vcn_id = "${oci_core_virtual_network.lb.id}"

  egress_security_rules = [
    {
      protocol = "${local.all_protocol}"
      destination = "${local.anywhere}"
    }]

  ingress_security_rules = [
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.anywhere}"

      tcp_options {
        "min" = "${var.hc_port}"
        "max" = "${var.hc_port}"
      }
    },
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.anywhere}"

      tcp_options {
        "min" = 22
        "max" = 22
      }
    },
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.anywhere}"

      tcp_options {
        "min" = 80
        "max" = 80
      },

    },
    {
      protocol = "${local.tcp_protocol}"
      source = "${local.anywhere}"

      tcp_options {
        "min" = 443
        "max" = 443
      }
    }
  ]
}

resource "oci_core_subnet" "lb" {
  count = "${local.lb_subnet_count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index], "name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.display_name_prefix}_lb_ad${count.index+1}"
  cidr_block = "${cidrsubnet("${local.lb_subnet_prefix}", 4, count.index)}"
  security_list_ids = ["${slice(local.lb_sec_list_ids, 0, var.non_ssl_listener_port != "" ? 2 : 1)}"]
  vcn_id = "${oci_core_virtual_network.lb.id}"
  route_table_id = "${oci_core_route_table.lb.id}"
  dhcp_options_id = "${oci_core_virtual_network.lb.default_dhcp_options_id}"
}

resource "oci_core_subnet" "bs" {
  count = "${var.backend_count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index], "name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${var.display_name_prefix}_bs_ad${count.index+1}"
  cidr_block = "${cidrsubnet("${local.bs_subnet_prefix}", 4, count.index)}"
  security_list_ids = ["${oci_core_security_list.bs.id}"]
  vcn_id = "${oci_core_virtual_network.lb.id}"
  route_table_id = "${oci_core_route_table.lb.id}"
  dhcp_options_id = "${oci_core_virtual_network.lb.default_dhcp_options_id}"
}
