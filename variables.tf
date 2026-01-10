variable "name" {
  type = string
}

variable "location" {
  type = string
}

variable "address_prefixes" {
  type = list(string)
}

variable "allocation_method" {
  type = string
}

variable "sku" {
  type = string
}

variable "private_ip_address_allocation" {
  type = string
}


variable "security_rule" {
  type = map(any)
}

variable "address_space" {
  type = list(string)
}

variable "size" {
  type = string
}

variable "admin_username" {
  type = string
}

variable "admin_password" {
  type = string
}

variable "disable_password_authentication" {
  type = string
}