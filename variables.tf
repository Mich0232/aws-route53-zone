variable "domain" {
  type = string
}

variable "project_name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "no_certificate" {
  type    = bool
  default = false
}

variable "certificate" {
  type = optional(object({
    arn = string
    domain_validation_options = list(object({
      domain_name           = string
      resource_record_name  = string
      resource_record_value = string
      resource_record_type  = string
    }))
  }))
  default = null
}

variable "records" {
  type = set(object({
    name    = string
    type    = string
    ttl     = optional(number)
    records = list(string)
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, false)
    }))
  }))
}

variable "default_ttl" {
  type    = number
  default = 300
}

locals {
  create_certificate = var.certificate == null
  resource_tags = merge(var.tags, {
    Project = var.project_name
  })
}
