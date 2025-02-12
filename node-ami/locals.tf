locals {
  resource_name = "${var.project_name}" 
  node_exporter_sg_id = "${var.node_sg_id}"
  node_exporter_subnet_id = "${var.node_subnet_id}"
}

  # db_subnet_ids = split(",", data.aws_ssm_parameter.database_subnet_ids[*].value)