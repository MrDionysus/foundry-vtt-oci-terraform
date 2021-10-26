resource "oci_budget_budget" "foundry_budget" {
    amount = var.budget_amount
    compartment_id = var.tenancy_ocid
    reset_period = "MONTHLY"
    description = "Foundry Budget "
    display_name = "foundry_budget"
    target_type  = "COMPARTMENT"
    targets      = [var.tenancy_ocid]
}

resource "oci_budget_alert_rule" "foundry_alert_rule" {
    #Required
    budget_id = oci_budget_budget.foundry_budget.id
    threshold = 1
    threshold_type = "PERCENTAGE"
    type = "FORECAST"
    recipients = var.alert_rule_recipients
    message = "Budget for Foundry resources in Oracle Cloud Infrastructure (OCI) has been exceeded."
}