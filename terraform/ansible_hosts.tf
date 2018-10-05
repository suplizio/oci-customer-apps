data "template_file" "ansible_hosts" {
  template = "${file(var.hosts_tpl_filename)}"
  count = "${length(oci_core_instance.servers.*.public_ip)}"
  vars {
    public_ips = "${oci_core_instance.servers.*.public_ip[count.index]}"
  }
}

resource "null_resource" "create_hosts_file" {
  triggers {
    test = "${data.template_file.ansible_hosts.rendered}"
  }
  provisioner "local-exec" {
    command = "echo \"${data.template_file.ansible_hosts.rendered}\" > ../${var.ansible_files_dir}/${var.ansible_hosts_filename}"
  }
}