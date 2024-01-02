# Floating IP

variable "floatip" {
  description = "Floating IP"
  type = object({
    region       = string
    component_id = string
  })
}
