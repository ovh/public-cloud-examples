variable "routes" {
  description = "Subnet Routes"
  type = list(object({
    region          = string
    next_hop_route1 = string
    next_hop_route2 = string
    dest_route1     = string
    dest_route2     = string
  }))
}
