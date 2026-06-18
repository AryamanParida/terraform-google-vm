variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "base_instance_name" {
  type = string
}

variable "zone" {
  type = string
}

variable "instance_template" {
  description = "Self-link of the instance template. Ignored on update when lifecycle.ignore_changes=[version] is active."
  type        = string
}

variable "version_name" {
  description = "Optional name for the version block. Leave null for GKE-managed IGMs."
  type        = string
  default     = null
}

variable "deletion_policy" {
  type    = string
  default = "ABANDON"
}

variable "target_size" {
  type    = number
  default = null
}

variable "target_stopped_size" {
  type    = number
  default = null
}

variable "target_suspended_size" {
  type    = number
  default = null
}

variable "wait_for_instances" {
  type    = bool
  default = false
}

variable "wait_for_instances_status" {
  type    = string
  default = "STABLE"
}

variable "list_managed_instances_results" {
  type    = string
  default = "PAGINATED"
}

variable "update_policy" {
  type    = any
  default = null
}

variable "instance_lifecycle_policy" {
  type    = any
  default = null
}

variable "standby_policy" {
  type    = any
  default = null
}

variable "named_ports" {
  type    = list(object({ name = string, port = number }))
  default = []
}

variable "auto_healing_policies" {
  type = list(object({
    health_check      = string
    initial_delay_sec = number
  }))
  default = []
}
