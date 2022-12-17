## AWS Route53 Hosted zone

This Terraform module create a R53 hosted zone with attached SSL certificate.

### Default records: 

 - ACM validation records
 - CNAME www.(domain)

### Inputs

`domain` - name of domain to be added.

`project_name` - Project name, will be used to prefix and tag AWS resources.

`no_certificate` - Don't use/generate SSL certificate``

`certificate` - ACM certificate data. If not provided SSL certificate will be generated.

```terraform
{
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
```

`renewal_eligibility` - Whether the certificate is eligible for managed renewal.

`records` - set of DNS records.

```terraform
{
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
```

`default_ttl` - TTL of default records, listed above. (default: 300s)

`tags` - Extra tags

### Outputs

`id` - ID of create hosted zone

`name_servers` - List of name servers

`certificate_arn` - ARN of SSL certificate attached to domain.
