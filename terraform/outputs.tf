// Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.

output "lb_id" {
  value = ["${module.load_balancer.id}"]
}

output "lb_ip_address" {
  value = ["${module.load_balancer.ip_addresses}"]
}

output "backend_public_ips" {
  value = ["${oci_core_instance.servers.*.public_ip}"]
}

output "backend_private_ips" {
  value = ["${oci_core_instance.servers.*.private_ip}"]
}
/*

output "ansible_hosts_file" {
  value = ["${data.template_file.ansible_hosts.*.rendered}"]
}
*/
