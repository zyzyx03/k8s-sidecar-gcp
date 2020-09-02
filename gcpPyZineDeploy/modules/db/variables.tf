// db module


variable "disk_size" {
  description = "The size in GB of the disk used by the db"
  type        = number
}

variable "instance_type" {
  description = "The instance type of the VM that will run the db (e.g. db-f1-micro, db-custom-8-32768)"
  type        = string
}

variable "password" {
  description = "The db password used to connect to the Postgers db"
  type        = string
}

variable "user" {
  description = "The username of the db user"
  type        = string
}



