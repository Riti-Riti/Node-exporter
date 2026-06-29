variable "task_family" {
  type    = string
  default = "node-exporter"
}

variable "container_name" {
  type    = string
  default = "node-exporter"
}

variable "container_image" {
  type = string
}


variable "memory" {
  type    = string
  default = "512"
}

variable "memory_reservation" {
  type    = number
  default = 500
}

variable "container_port" {
  type    = number
  default = 9100
}

variable "host_port" {
  type    = number
  default = 9100
}

variable "proc_path" {
  type    = string
  default = "/proc"
}

variable "sys_path" {
  type    = string
  default = "/sys"
}

variable "tags" {
  type = map(string)
}
