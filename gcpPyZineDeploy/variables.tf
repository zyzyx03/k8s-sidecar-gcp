variable "db_password" { 
  description = "The mysql password" 
  type        = string 
  default     = "trymenow" 
} 
 
variable "db_username"{ 
  type = string       
  default= "zyzyx" 
} 

variable "gcp_project_name"{
  type = string
  default= "pyzine-288209"
}

variable "gcp_region"{  
  type = string     
  default= "asia-southeast1"
}

variable "gcp_zone"{
  type = string
  default = "asia-southeast1-a"
}

variable "k8s_name" {
  type = string
  default = "demo-cluster"
}

variable "initial_node_count" {
  default = 1
}



