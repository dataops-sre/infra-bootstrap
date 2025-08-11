resource "helm_release" "traefik-private-ingress-controller" {
  name             = "traefik-private-ingress-controller"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  namespace        = "traefik-internal"
  create_namespace = false
  max_history      = 5
  atomic           = true
  version          = "v36.3.0"
  timeout          = 600
}
