resource "oci_core_instance" "servers" {
  count               = "${var.backend_count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ad.availability_domains[count.index], "name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "${var.display_name_prefix}_srv${count.index+1}"
  shape               = "${var.backend_shape}"
  subnet_id           = "${element(oci_core_subnet.bs.*.id, count.index)}"

  metadata {
    ssh_authorized_keys = "${file("${var.ssh_authorized_keys}")}"
    assign_public_ip    = "${var.assign_public_ip}"
    user_data = "${base64encode(file(var.bootstrap_file))}"
  }

  source_details {
    source_id   = "${var.image_ids[var.region]}"
    source_type = "image"
  }
}