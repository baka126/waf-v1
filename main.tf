
provider "aws" {
  # Ensure you have the appropriate AWS credentials and region configured
  region = "your-aws-region"
}

resource "aws_wafv2_web_acl" "web_acl" {
  name        = var.web_acl_name
  scope       = "CLOUDFRONT" # Use "REGIONAL" for ALB, "CLOUDFRONT" for CloudFront
  description = "AWS WAF WebACL for protecting the application"
  default_action {
    allow {}
  }
}

resource "aws_wafv2_web_acl_association" "web_acl_association" {
  resource_arn = var.resource_arn
  web_acl_arn  = aws_wafv2_web_acl.web_acl.arn
}

resource "aws_wafv2_rule_group" "rule_group" {
  name        = "your-rule-group-name"
  scope       = var.resource_type == "alb" ? "REGIONAL" : "CLOUDFRONT"
  description = "Rule group for AWS WAF"
  capacity    = 100
  rules {
    priority    = var.rule_priority
    name        = var.rule_name
    action {
      block {}
    }
    statement {
      or_statement {
        statements = var.statement
      }
    }
  }
}

resource "aws_wafv2_web_acl_rule_group_insertion" "rule_group_insertion" {
  name        = aws_wafv2_web_acl.web_acl.name
  priority    = var.priority
  rule_action {
    block {}
  }
  web_acl_arn = aws_wafv2_web_acl.web_acl.arn
  rule_group_reference_statement {
    name = aws_wafv2_rule_group.rule_group.name
  }
}
