########################################################################################
# Availability zone auto-selection
#
# For 3-AZ regions (EU-WEST-PAR, EU-SOUTH-MIL), the two OPNsense nodes are placed on
# separate availability zones in addition to the anti-affinity hypervisor constraint.
# For single-AZ regions, az_primary/az_secondary are null and OpenStack decides placement.
########################################################################################

locals {
  three_az_pairs = {
    "EU-WEST-PAR"  = [
      ["eu-west-par-a",  "eu-west-par-b"],
      ["eu-west-par-a",  "eu-west-par-c"],
      ["eu-west-par-b",  "eu-west-par-c"],
    ]
    "EU-SOUTH-MIL" = [
      ["eu-south-mil-a", "eu-south-mil-b"],
      ["eu-south-mil-a", "eu-south-mil-c"],
      ["eu-south-mil-b", "eu-south-mil-c"],
    ]
  }

  is_3az        = contains(keys(local.three_az_pairs), upper(var.region))
  az_pair_count = local.is_3az ? length(local.three_az_pairs[upper(var.region)]) : 1
  _az_pairs     = lookup(local.three_az_pairs, upper(var.region), [["", ""]])
  az_primary    = local.is_3az ? local._az_pairs[random_integer.az_pair.result][0] : null
  az_secondary  = local.is_3az ? local._az_pairs[random_integer.az_pair.result][1] : null
}

resource "random_integer" "az_pair" {
  min = 0
  max = local.az_pair_count - 1
  keepers = {
    region = var.region
  }
}
