**Note:** This module is currently available for internal-Oracle consumption as part of a Limited Availability release. See [Oracle Cloud Infrastructure Terraform Modules](https://confluence.oraclecorp.com/confluence/display/BMCS/OCI+Terraform+Modules) for information about how to use this module and how to give feedback.

# Oracle Cloud Infrastructure Load Balancer Terraform Module

The Oracle Cloud Infrastructure Load Balancer Terraform Module provides an easy way set up an Oracle Cloud Infrastructure Local Balancer with multiple backends, health checks, listeners, and other features, using sensible defaults and a simplified interface. For information about Oracle Cloud Infrastructure Load Balancers, see [Overview of Load Balancing](https://docs.cloud.oracle.com/iaas/Content/Balance/Concepts/balanceoverview.htm).

The Oracle Cloud Infrastructure Load Balancer Terraform module has some limitations:

* You can have only one backend set.
* There is no backend set certificate.
* There are only zero or one path routes available for the backend set.
* You can have only zero or one non-SSL listeners.
* You can have only zero or one SSL-enabled listeners.
* You can have just one certificate for SSL-enabled listeners.

## Prerequisites

1. [Download and install Terraform](https://www.terraform.io/downloads.html) (v0.10.3 or later)
2. [Download and install the Oracle Cloud Infrastructure Terraform Provider](https://github.com/oracle/terraform-provider-oci) (v2.1.2 or later)

## How to Use the Module

The following example

```hcl
module "load_balancer" {
  source               = "../"
  compartment_id                  = "${var.compartment_ocid}"
  display_name                    = "${var.display_name}"
  shape                           = "${var.shape}"
  is_private                      = "${var.is_private}"
  subnet_ids                      = ["${var.subnet_ids}"]
  backendset_name                 = "${var.backendset_name}"
  backendset_policy               = "${var.backendset_policy}"
  hc_protocol                     = "${var.hc_protocol}"
  hc_port                         = "${var.hc_port}"
  hc_interval_ms                  = "${var.hc_interval_ms}"
  hc_retries                      = "${var.hc_retries}"
  hc_return_code                  = "${var.hc_return_code}"
  hc_timeout_in_millis            = "${var.hc_timeout_in_millis}"
  hc_response_body_regex          = "${var.hc_response_body_regex}"
  hc_url_path                     = "${var.hc_url_path}"
  backend_count                   = "${var.backend_count}"
  backend_ips                     = ["${var.backend_ips}"]
  backend_ports                   = "${var.backend_ports}"
  backup                          = "${var.backup}"
  drain                           = "${var.drain}"
  offline                         = "${var.offline}"
  weight                          = "${var.weight}"
  path_route_set_name             = "${var.path_route_set_name}"
  path                            = "${var.path}"
  path_match_type                 = "${var.path_match_type}"
  hostnames                       = "${var.hostnames}"
  hostname_names                  = "${var.hostname_names}"
  listener_certificate_name       = "${var.listener_certificate_name}"
  listener_ca_certificate         = "${var.listener_ca_certificate}"
  listener_passphrase             = "${var.listener_passphrase}"
  listener_private_key            = "${var.listener_private_key}"
  listener_public_certificate     = "${var.listener_public_certificate}"
  listener_protocol               = "${var.listener_protocol}"
  ssl_listener_name               = "${var.ssl_listener_name}"
  ssl_listener_port               = "${var.ssl_listener_port}"
  ssl_verify_peer_certificate     = "${var.ssl_verify_peer_certificate}"
  ssl_verify_depth                = "${var.ssl_verify_depth}"
  ssl_listener_hostnames          = "${var.ssl_listener_hostnames}"
  ssl_listener_path_route_set     = "${var.ssl_listener_path_route_set}"
  non_ssl_listener_name           = "${var.non_ssl_listener_name}"
  non_ssl_listener_port           = "${var.non_ssl_listener_port}"
  non_ssl_listener_hostnames      = "${var.non_ssl_listener_hostnames}"
  non_ssl_listener_path_route_set = "${var.non_ssl_listener_path_route_set}"
}
```

**Following are arguments available to the Load Balancer module:**

Argument | Description
--- | ---
compartment_id | Unique identifier (OCID) of the compartment in which to create the load balancer.
display_name | Display name of the load balancer.
shape | The shape of the load balancer.
subnet_ids | Lists the IDs of the subnets that host the load balancer.
is_private | Specifies whether to create a public or private load balancer. If `true`, the load balancer is private.
backendset_name | Name of the backend set/
backendset_policy | The load balancer policy for the backend set.
hc_protocol | Specifies the health checker protocol.
hc_port | Specifies the backend server port against which to run the health check.
hc_interval_ms | Specifies how frequently to run the health check.
hc_retries | Specifies the number of retries to attempt before a backend server is considered unhealthy.
hc_return_code | The status code returned by a healthy backend server.
hc_timeout_in_millis | Specifies the maximum time in milliseconds to wait for a reply to a health check.
hc_response_body_regex | A regular expression for parsing the response body returned from the backend server.
hc_url_path | The endpoint URL against which to run the health check.
backend_count | Specifies the number of the backend servers.
backend_ips | The IP addresses of the backend servers.
backend_ports | The communication port for the backend server.
backup | Specifies whether the load balancer should treat this server as a backup unit. If `true`, this is a backup unit.
drain | Specifies whether the load balancer should drain the specified server. If `true`, drain.
offline | Specifies whether the load balancer should treat the specified server as offline. `Ture` if an offline server.
weight | Specifies the load balancing policy weight assigned to the server.
path_route_set_name | Name of the rule set for the path-based routing rules.
path | The path string to match against the incoming URI path.
path_match_type | The matching type to apply to incoming URIs.
hostnames | A list of virtual hostnames.
hostname_names | A list of friendly names for the hostname resources.
listener_certificate_name | The friendly name of the listener's SSL certificate.
listener_ca_certificate | The associated Certificate Authority certificate.
listener_passphrase | The passphrase for the certificate.
listener_private_key | The private key for the certificate.
listener_public_certificate | The certificate in PEM format.
listener_protocol | The protocol on which the listener accepts connection requests, either HTTP or TCP.
ssl_listener_name | The name of the listener that has SSL enabled.
ssl_listener_port | The communication port of the listener that has SSL enabled.
ssl_verify_peer_certificate | Enables peer certificate verification.
ssl_verify_depth | The maximum depth for certificate chain verification.
ssl_listener_hostnames | The hostname resources for the listener that has SSL enabled.
ssl_listener_path_route_set | The path route set name for the listener that has SSL enabled. This applies only to HTTP and HTTPS requests.
non_ssl_listener_name | The name of the listener that does not have SSL enabled.
non_ssl_listener_port | The communication port for the listener that does not have SSL enabled.
non_ssl_listener_hostnames | The hostname of the listener that does not have SSL enabled.
non_ssl_listener_path_route_set | The name of the path route set for the listener that does not have SSL enabled. This applies only to HTTP and HTTPS requests

## Contributing

This project is open source. Oracle appreciates any contributions that are made by the open source community.

## License

Copyright (c) 2018, Oracle and/or its affiliates. All rights reserved.

This SDK and sample is dual licensed under the Universal Permissive License 1.0 and the Apache License 2.0.
Licensed under the Universal Permissive License 1.0 or Apache License 2.0.

See [LICENSE](/LICENSE.txt) for more details.
