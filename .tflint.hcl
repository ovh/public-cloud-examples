# Let's be very strict from the ground up and enable everything.
# All rules are define here: https://github.com/terraform-linters/tflint/tree/master/docs/rules
rule "terraform_comment_syntax" {
  enabled = false
}
rule "terraform_deprecated_index" {
  enabled = false
}
rule "terraform_deprecated_interpolation" {
  enabled = false
}
rule "terraform_documented_outputs" {
  enabled = false
}
rule "terraform_documented_variables" {
  enabled = false
}
rule "terraform_module_pinned_source" {
  enabled = false
}
rule "terraform_module_version" {
  enabled = false
}
rule "terraform_naming_convention" {
  enabled = false
}
rule "terraform_required_providers" {
  enabled = false
}
rule "terraform_required_version" {
  enabled = false
}
rule "terraform_standard_module_structure" {
  enabled = false
}
rule "terraform_typed_variables" {
  enabled = false
}
rule "terraform_unused_declarations" {
  enabled = false
}
rule "terraform_unused_required_providers" {
  enabled = false
}
rule "terraform_workspace_remote" {
  enabled = false
}
