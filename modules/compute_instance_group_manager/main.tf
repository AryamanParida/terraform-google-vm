/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_compute_instance_group_manager" "this" {
  provider = google

  name               = var.name
  base_instance_name = var.base_instance_name
  project            = var.project_id
  zone               = var.zone

  deletion_policy                = var.deletion_policy
  target_size                    = var.target_size
  target_stopped_size            = var.target_stopped_size
  target_suspended_size          = var.target_suspended_size
  wait_for_instances             = var.wait_for_instances
  wait_for_instances_status      = var.wait_for_instances_status
  list_managed_instances_results = var.list_managed_instances_results

  version {
    # GKE rotates the template; ignore_changes suppresses drift after import.
    # When instance_template is not provided, use a placeholder that satisfies
    # the provider's required-field check without triggering a real change.
    instance_template = var.instance_template != "" ? var.instance_template : "projects/${var.project_id}/global/instanceTemplates/placeholder-managed-externally"
    name              = var.version_name
  }

  dynamic "target_size_policy" {
    for_each = var.target_size_policy != null ? [var.target_size_policy] : []
    content {
      mode = lookup(target_size_policy.value, "mode", null)
    }
  }

  dynamic "update_policy" {
    for_each = var.update_policy != null ? [var.update_policy] : []
    content {
      type                    = update_policy.value.type
      minimal_action          = update_policy.value.minimal_action
      max_surge_fixed         = lookup(update_policy.value, "max_surge_fixed", null)
      max_surge_percent       = lookup(update_policy.value, "max_surge_percent", null)
      max_unavailable_fixed   = lookup(update_policy.value, "max_unavailable_fixed", null)
      max_unavailable_percent = lookup(update_policy.value, "max_unavailable_percent", null)
      replacement_method      = lookup(update_policy.value, "replacement_method", null)
    }
  }

  dynamic "instance_lifecycle_policy" {
    for_each = var.instance_lifecycle_policy != null ? [var.instance_lifecycle_policy] : []
    content {
      default_action_on_failure = lookup(instance_lifecycle_policy.value, "default_action_on_failure", null)
      force_update_on_repair    = lookup(instance_lifecycle_policy.value, "force_update_on_repair", null)
    }
  }

  dynamic "standby_policy" {
    for_each = var.standby_policy != null ? [var.standby_policy] : []
    content {
      initial_delay_sec = lookup(standby_policy.value, "initial_delay_sec", null)
      mode              = lookup(standby_policy.value, "mode", null)
    }
  }

  dynamic "named_port" {
    for_each = var.named_ports
    content {
      name = named_port.value.name
      port = named_port.value.port
    }
  }

  dynamic "auto_healing_policies" {
    for_each = var.auto_healing_policies
    content {
      health_check      = auto_healing_policies.value.health_check
      initial_delay_sec = auto_healing_policies.value.initial_delay_sec
    }
  }

  lifecycle {
    # GKE and other controllers rotate the instance template automatically.
    # Ignoring version prevents spurious diffs when the template is updated
    # outside Terraform.
    ignore_changes = [version]
  }
}
