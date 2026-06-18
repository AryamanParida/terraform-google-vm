variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "target" {
  description = "Self-link of the IGM to autoscale."
  type        = string
}

variable "zone" {
  description = "Zone for a zonal autoscaler. Exactly one of zone or region must be set."
  type        = string
  default     = null
}

variable "region" {
  description = "Region for a regional autoscaler. Exactly one of zone or region must be set."
  type        = string
  default     = null
}

variable "deletion_policy" {
  type    = string
  default = "DELETE"
}

variable "max_replicas" {
  type = number
}

variable "min_replicas" {
  type = number
}

variable "cooldown_period" {
  type    = number
  default = 60
}

variable "mode" {
  type    = string
  default = "ON"
}

variable "stabilization_period" {
  type    = number
  default = 0
}

variable "cpu_utilization" {
  type    = any
  default = null
}

variable "metrics" {
  type    = list(any)
  default = []
}
