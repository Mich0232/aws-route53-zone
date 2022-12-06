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

variable "records" {
  type = set(object({
    name    = string
    type    = string
    ttl     = optional(number, 300)
    records = list(string)
    alias = optional(object({
      name                   = string
      zone_id                = string
      evaluate_target_health = optional(bool, false)
    }))
  }))
}

variable "record_ttl" {
  type    = number
  default = 300
}

locals {
  resource_tags = merge(var.tags, {
    Project = var.project_name
  })
}
