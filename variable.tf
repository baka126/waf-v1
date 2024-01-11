# Web ACL Configuration Variables
variable "name" {
  type        = string
  description = "A friendly name of the WebACL."
}

variable "scope" {
  type        = string
  description = "The scope of this Web ACL. Valid options: CLOUDFRONT, REGIONAL."
}

variable "default_action" {
  type        = string
  description = "The action to perform if none of the rules contained in the WebACL match."
  default     = "allow"
}

# Managed Rules Configuration
variable "managed_rules" {
  type        = list(object({
    name                 = string
    priority             = number
    override_action      = string
    vendor_name          = string
    version              = optional(string)
    rule_action_override = list(object({
      name          = string
      action_to_use = string
    }))
  }))
  description = "List of Managed WAF rules."
  default = [
    {
      name                 = "AWSManagedRulesCommonRuleSet"
      # ... other default values
    },
    # ... additional managed rules
  ]
}

# IP Set Rule Configuration
variable "ip_sets_rule" {
  type        = list(object({
    name          = string
    priority      = number
    ip_set_arn    = string
    action        = string
    response_code = optional(number, 403)
  }))
  description = "A rule to detect web requests coming from particular IP addresses or address ranges."
  default     = []
}

# IP Rate-Based Rule Configuration
variable "ip_rate_based_rule" {
  type        = object({
    name          = string
    priority      = number
    limit         = number
    action        = string
    response_code = optional(number, 403)
  })
  description = "A rate-based rule tracks the rate of requests for each originating IP address."
  default     = null
}

# IP Rate URL-Based Rules Configuration
variable "ip_rate_url_based_rules" {
  type        = list(object({
    name                  = string
    priority              = number
    limit                 = number
    action                = string
    response_code         = optional(number, 403)
    search_string         = string
    positional_constraint = string
  }))
  description = "A rate and URL-based rule tracks the rate of requests for each originating IP address."
  default     = []
}

# Filtered Header Rule Configuration
variable "filtered_header_rule" {
  type        = object({
    header_types  = list(string)
    priority      = number
    header_value  = string
    action        = string
    search_string = string
  })
  description = "HTTP header to filter."
  default = {
    header_types  = []
    priority      = 1
    header_value  = ""
    action        = "block"
    search_string = ""
  }
}

# Logging Configuration Variables
variable "enable_logging" {
  type        = bool
  description = "Whether to associate Logging resource with the WAFv2 ACL."
  default     = false
}

variable "log_destination_arns" {
  type        = list(string)
  description = "The ARNs of resources for logging."
  default     = []
}

# Association Variables
variable "associate_alb" {
  type        = bool
  description = "Whether to associate an ALB with the WAFv2 ACL."
  default     = false
}

variable "alb_arn" {
  type        = string
  description = "ARN of the ALB to be associated with the WAFv2 ACL."
  default     = ""
}

# Rule Group Configuration
variable "group_rules" {
  type        = list(object({
    name            = string
    arn             = string
    priority        = number
    override_action = string
  }))
  description = "List of WAFv2 Rule Groups."
  default     = []
}

# Tags Configuration
variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the WAFv2 ACL."
  default     = {}
}
