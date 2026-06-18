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

locals {
  is_regional = var.region != null && var.zone == null
}

resource "google_compute_autoscaler" "this" {
  count    = local.is_regional ? 0 : 1
  provider = google

  name            = var.name
  project         = var.project_id
  zone            = var.zone
  target          = var.target
  deletion_policy = var.deletion_policy

  autoscaling_policy {
    max_replicas         = var.max_replicas
    min_replicas         = var.min_replicas
    cooldown_period      = var.cooldown_period
    mode                 = var.mode
    stabilization_period = var.stabilization_period

    dynamic "cpu_utilization" {
      for_each = var.cpu_utilization != null ? [var.cpu_utilization] : []
      content {
        target            = cpu_utilization.value.target
        predictive_method = lookup(cpu_utilization.value, "predictive_method", null)
      }
    }

    dynamic "metric" {
      for_each = var.metrics
      content {
        name                       = metric.value.name
        target                     = lookup(metric.value, "target", null)
        type                       = lookup(metric.value, "type", null)
        single_instance_assignment = lookup(metric.value, "single_instance_assignment", null)
        filter                     = lookup(metric.value, "filter", null)
      }
    }
  }
}

resource "google_compute_region_autoscaler" "this" {
  count    = local.is_regional ? 1 : 0
  provider = google

  name            = var.name
  project         = var.project_id
  region          = var.region
  target          = var.target
  deletion_policy = var.deletion_policy

  autoscaling_policy {
    max_replicas         = var.max_replicas
    min_replicas         = var.min_replicas
    cooldown_period      = var.cooldown_period
    mode                 = var.mode
    stabilization_period = var.stabilization_period

    dynamic "cpu_utilization" {
      for_each = var.cpu_utilization != null ? [var.cpu_utilization] : []
      content {
        target            = cpu_utilization.value.target
        predictive_method = lookup(cpu_utilization.value, "predictive_method", null)
      }
    }

    dynamic "metric" {
      for_each = var.metrics
      content {
        name                       = metric.value.name
        target                     = lookup(metric.value, "target", null)
        type                       = lookup(metric.value, "type", null)
        single_instance_assignment = lookup(metric.value, "single_instance_assignment", null)
        filter                     = lookup(metric.value, "filter", null)
      }
    }
  }
}
