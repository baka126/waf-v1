# This Terraform module configures AWS WAFv2 Web ACL for protecting resources behind an Application Load Balancer (ALB).
# It includes settings for managed rules, IP sets, rate-based rules, header filtering, and rule groups.

resource "aws_wafv2_web_acl" "main" {
  name        = var.name
  description = "WAFv2 ACL for ${var.name}"

  scope = var.scope

  # Default Action Settings
  default_action {
    dynamic "allow" {
      for_each = var.default_action == "allow" ? [1] : []
      content {}
    }

    dynamic "block" {
      for_each = var.default_action == "block" ? [1] : []
      content {}
    }
  }

  # Visibility Configuration
  visibility_config {
    cloudwatch_metrics_enabled = true
    sampled_requests_enabled   = true
    metric_name                = var.name
  }

  # Managed Rules Configuration
  dynamic "rule" {
    for_each = var.managed_rules
    content {
      # Rule Settings
      name     = rule.value.name
      priority = rule.value.priority

      # Override Action Settings
      override_action {
        dynamic "none" {
          for_each = rule.value.override_action == "none" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.override_action == "count" ? [1] : []
          content {}
        }
      }

      # Statement for Managed Rule Group
      statement {
        managed_rule_group_statement {
          name        = rule.value.name
          vendor_name = rule.value.vendor_name
          version     = rule.value.version

          # Rule Action Override Settings
          dynamic "rule_action_override" {
            for_each = rule.value.rule_action_override
            content {
              name = rule_action_override.value["name"]
              
              # Action to Use Settings
              dynamic "allow" {
                for_each = rule_action_override.value["action_to_use"] == "allow" ? [1] : []
                content {}
              }

              dynamic "block" {
                for_each = rule_action_override.value["action_to_use"] == "block" ? [1] : []
                content {}
              }

              dynamic "count" {
                for_each = rule_action_override.value["action_to_use"] == "count" ? [1] : []
                content {}
              }
            }
          }
        }
      }

      # Visibility Configuration for the Rule
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  # IP Set Rules Configuration
  dynamic "rule" {
    for_each = var.ip_sets_rule
    content {
      # Rule Settings
      name     = rule.value.name
      priority = rule.value.priority

      # Action Settings
      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {
            # Custom Response for Block Action
            dynamic "custom_response" {
              for_each = rule.value.response_code != 403 ? [1] : []
              content {
                response_code = rule.value.response_code
              }
            }
          }
        }
      }

      # Statement for IP Set Reference
      statement {
        ip_set_reference_statement {
          arn = rule.value.ip_set_arn
        }
      }

      # Visibility Configuration for the Rule
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  # Rate-Based IP Rule Configuration
  dynamic "rule" {
    for_each = var.ip_rate_based_rule != null ? [var.ip_rate_based_rule] : []
    content {
      # Rule Settings
      name     = rule.value.name
      priority = rule.value.priority

      # Action Settings
      action {
        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {
            # Custom Response for Block Action
            dynamic "custom_response" {
              for_each = rule.value.response_code != 403 ? [1] : []
              content {
                response_code = rule.value.response_code
              }
            }
          }
        }
      }

      # Statement for Rate-Based IP
      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = "IP"
        }
      }

      # Visibility Configuration for the Rule
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  # Rate-Based URL Rule Configuration
  dynamic "rule" {
    for_each = var.ip_rate_url_based_rules
    content {
      # Rule Settings
      name     = rule.value.name
      priority = rule.value.priority

      # Action Settings
      action {
        dynamic "allow" {
          for_each = rule.value.action == "allow" ? [1] : []
          content {}
        }

        dynamic "count" {
          for_each = rule.value.action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = rule.value.action == "block" ? [1] : []
          content {
            # Custom Response for Block Action
            dynamic "custom_response" {
              for_each = rule.value.response_code != 403 ? [1] : []
              content {
                response_code = rule.value.response_code
              }
            }
          }
        }
      }

      # Statement for Rate-Based URL
      statement {
        rate_based_statement {
          limit              = rule.value.limit
          aggregate_key_type = "IP"
          
          # Scope Down Statement for URL Match
          scope_down_statement {
            byte_match_statement {
              positional_constraint = rule.value.positional_constraint
              search_string         = rule.value.search_string
              field_to_match {
                uri_path {}
              }
              text_transformation {
                priority = 0
                type     = "URL_DECODE"
              }
            }
          }
        }
      }

      # Visibility Configuration for the Rule
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = rule.value.name
        sampled_requests_enabled   = true
      }
    }
  }

  # Filtered Header Rule Configuration
  dynamic "rule" {
    for_each = [for header_name in var.filtered_header_rule.header_types : {
      priority      = var.filtered_header_rule.priority + index(var.filtered_header_rule.header_types, header_name) + 1
      name          = header_name
      header_value  = var.filtered_header_rule.header_value
      action        = var.filtered_header_rule
}
]

}
}
