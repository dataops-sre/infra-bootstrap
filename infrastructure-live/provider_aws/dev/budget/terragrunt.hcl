terraform {
  source = "git::https://github.com/boldlink/terraform-aws-budget?ref=1.0.2"
}

include {
  path = find_in_parent_folders("root.hcl")
}

inputs = {
  name         = "aws-free-tier-budget"
  limit_amount = "10"
  budget_type  = "COST"
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_types = {
    include_tax          = true
    include_subscription = true
    use_blended          = false
  }

  notification = [
    {
      comparison_operator        = "GREATER_THAN"
      threshold                  = 80
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = [get_env("BUDGET_ALERT_EMAIL", "myemail@example.com")]
    }
  ]

}
