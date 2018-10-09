provider "oci" {
  auth                 = "InstancePrincipal"
  region               = "${var.region}"
  disable_auto_retries = "true"
}
