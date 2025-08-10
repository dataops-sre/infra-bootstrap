output "namespaces" {
  value = {
    for group in var.groups :
    group.name => [
      for namespace in group.namespaces : namespace.name
    ]
  }
}
