variable "host" {
  type = string
}

variable "cluster_name" {
  type = string
}
variable "cluster_ca_certificate" {
  type = string
}

variable "groups" {
  description = "groups and namespaces managed by this module"
  type = list(object({
    name = string
    namespaces = list(object({
      name              = string
      labels            = optional(map(string), {})
      annotations       = optional(map(string), {})
      quotas            = optional(string)
      enable_goldilocks = optional(string, "true")
    }))
  }))
}

variable "limits" {
  description = "Mapping for the Limit Range configuration, the LimitRange configuration here is only enforcing defaults for pods that doesn't specify resource requests or memory limits"
  type = list(object({
    type                    = string
    default_request         = optional(map(string), {})
    min                     = optional(map(string), {})
    max                     = optional(map(string), {})
    max_limit_request_ratio = optional(map(string), {})
  }))
  default = [
    {
      type : "Container"
      default_request = {
        cpu : "10m",
        memory : "32Mi"
      }
    },
    {
      type : "PersistentVolumeClaim"
      max = {
        storage : "500Gi"
      }
    }
  ]
}

#Refer keys specifid in https://kubernetes.io/docs/concepts/policy/resource-quotas/
#This quota will be applied to all namespaces
variable "namespaced_resources_quota" {
  description = "Mapping for the Resource Quota configuration"
  type = object({
    pods     = string
    services = string
    secrets  = string
  })
  default = {
    pods     = "50"
    services = "50"
    secrets  = "100"
  }
}
