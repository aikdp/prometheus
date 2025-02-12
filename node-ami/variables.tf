variable "project_name"{
    default = "node-exporter"
}


variable "common_tags"{
    default = {
        Project = "node-exporter"
        Terraform = "true"
    }
}

variable "nide_tags"{
    default = {
        Component = "node-exporter"
    }
}

variable "zone_name"{
    default = "telugudevops.online"
}


variable "node_sg_id" {
    default = "sg-0f487d954cbe820ef"
}

variable "node_subnet_id" {
    default = "subnet-0f7c76cdf5db0d0b8"
}