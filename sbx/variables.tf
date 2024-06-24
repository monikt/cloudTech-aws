variable "region" {
  type    = string
  default = "us-east-1"
}

variable "profile" {
  type    = string
  default = "terraform-cloud-monica"
}

variable "users_for_developer" {
  type    = map(string)
  default = {}
}

variable "users_for_analytics" {
  type    = map(string)
  default = {}
}

variable "users_for_qa" {
  type    = map(string)
  default = {}
}

variable "users_for_tecnical_leaders" {
  type    = map(string)
  default = {}
}

variable "tecnical_leaders" {
  description = "Create IAM users with these names"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc_id"
  type        = string
}
variable "subnet_id" {
  type = list(string)
}

variable "prefix_buckets" {
  type    = list(string)
  default = [""]
}

variable "key_pair_name" {
  description = "key_pair_name"
  type        = string
}

variable "cidrs_available_vpce" {
  type    = map(string)
  default = {}
}
variable "cidrs_available_subnet" {
  type = map(object({
    cidr        = string
    zona_valida = string
  }))

  default = {}
}

variable "stage" {
  type    = string
  default = "desarrollo"
}


variable "cidrs_available_vpce_worshop_g" {
  type = map(object({
    vpc_name  = string
    cidr_vpce = string
  }))
  default = {}
}
variable "cidrs_available_subnet_worshop_g" {
  type = map(object({
    vpc_identificator = string
    cidr              = string
    zona_valida       = string
  }))

  default = {}
}


