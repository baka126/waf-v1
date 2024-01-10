module "waf_web_acl" {
  source = "path/to/module" # Replace with the actual path or URL of your module

  web_acl_name     = "my-web-acl"
  rule_name        = "my-rule"
  statement        = [/* Your WAF rule statements go here */]
  resource_type    = "alb" # or "cloudfront"
  resource_arn     = "your-resource-arn"
}
