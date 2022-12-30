variable "routes" {
  type = list(object({
    region        = string
    nextHopRoute1 = string
    nextHopRoute2 = string
    destRoute1    = string
    destRoute2    = string
  }))
}
