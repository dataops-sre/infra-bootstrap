locals {
  namespaces = flatten([
    for group in var.groups : [
      for namespace in group.namespaces : merge(
        namespace,
        { labels = merge(namespace.labels, { "engineering-group" = group.name }) },
        { annotations = namespace.annotations }
      )
    ]
  ])
}
