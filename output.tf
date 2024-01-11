output "web_acl_arn" {
  description = "The ARN of the created AWS WAFv2 Web ACL."
  value       = aws_wafv2_web_acl.main.arn
}

output "associated_alb_arn" {
  description = "The ARN of the associated ALB (if applicable)."
  value       = var.associate_alb ? aws_wafv2_web_acl_association.main[0].arn : null
}

output "logging_configuration_arn" {
  description = "The ARN of the configured logging destination (if logging is enabled)."
  value       = var.enable_logging ? aws_wafv2_web_acl_logging_configuration.main[0].arn : null
}

output "rule_group_arns" {
  description = "List of ARNs for configured WAFv2 Rule Groups."
  value       = [for rule in var.group_rules : rule.arn]
}

output "default_action" {
  description = "The default action specified in the Web ACL."
  value       = var.default_action
}

# Add more outputs based on your use case or requirements.
