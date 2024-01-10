variable "web_acl_name" {
  description = "Name for the AWS WAF WebACL"
  type        = string
}

variable "default_action" {
  description = "Default action for the WebACL"
  type        = string
  default     = "ALLOW" # You can customize the default value as needed
}

variable "priority" {
  description = "Priority for the WebACL rules"
  type        = number
  default     = 1 # You can customize the default value as needed
}

variable "rule_action" {
  description = "Action to be taken when a rule is matched"
  type        = string
  default     = "BLOCK" # You can customize the default value as needed
}

variable "rule_priority" {
  description = "Priority for the WAF rule"
  type        = number
  default     = 1 # You can customize the default value as needed
}

variable "rule_name" {
  description = "Name for the WAF rule"
  type        = string
}

variable "statement" {
  description = "Statement for the WAF rule"
  type        = list(any)
}

variable "resource_type" {
  description = "Type of resource (alb or cloudfront)"
  type        = string
}

variable "resource_arn" {
  description = "ARN of the resource to associate with the WebACL"
  type        = string
}
