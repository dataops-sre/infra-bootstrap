# terraform-kubernetes-namespaces
This module offers reusable code to be sourcing on a live module that has the intention to create kubernetes namespaces.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.23.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | gruntwork-io/namespace/kubernetes//modules/namespace | 0.5.1 |

## Resources

| Name | Type |
|------|------|
| kubernetes_default_service_account.default | resource |
| kubernetes_limit_range.this | resource |
| kubernetes_resource_quota.this | resource |
| kubernetes_secret.registry_credentials | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_certificate"></a> [client\_certificate](#input\_client\_certificate) | n/a | `string` | n/a | yes |
| <a name="input_client_key"></a> [client\_key](#input\_client\_key) | n/a | `string` | n/a | yes |
| <a name="input_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#input\_cluster\_ca\_certificate) | n/a | `string` | n/a | yes |
| <a name="input_groups"></a> [groups](#input\_groups) | groups and namespaces managed by this module | <pre>list(object({<br>    name = string<br>    namespaces = list(object({<br>      name              = string<br>      labels            = optional(map(string), {})<br>      annotations       = optional(map(string), {})<br>      quotas            = optional(string)<br>      enable_goldilocks = optional(string, "true")<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_host"></a> [host](#input\_host) | n/a | `string` | n/a | yes |
| <a name="input_limits"></a> [limits](#input\_limits) | Mapping for the Limit Range configuration, the LimitRange configuration here is only enforcing defaults for pods that doesn't specify resource requests or memory limits | <pre>list(object({<br>    type                    = string<br>    default_request         = optional(map(string), {})<br>    min                     = optional(map(string), {})<br>    max                     = optional(map(string), {})<br>    max_limit_request_ratio = optional(map(string), {})<br>  }))</pre> | <pre>[<br>  {<br>    "default_request": {<br>      "cpu": "10m",<br>      "memory": "32Mi"<br>    },<br>    "type": "Container"<br>  },<br>  {<br>    "max": {<br>      "storage": "500Gi"<br>    },<br>    "type": "PersistentVolumeClaim"<br>  }<br>]</pre> | no |
| <a name="input_namespaced_resources_quota"></a> [namespaced\_resources\_quota](#input\_namespaced\_resources\_quota) | Mapping for the Resource Quota configuration | <pre>object({<br>    pods     = string<br>    services = string<br>    secrets  = string<br>  })</pre> | <pre>{<br>  "pods": "50",<br>  "secrets": "100",<br>  "services": "50"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_namespaces"></a> [namespaces](#output\_namespaces) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
