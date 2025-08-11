resource "helm_release" "airflow-minimal" {
  name = "airflow-minimal"
  # Best practice is to remove the trailing slash from the repository URL
  repository       = "https://airflow.apache.org"
  chart            = "airflow"
  namespace        = "airflow"
  create_namespace = false
  max_history      = 5
  atomic           = true
  version          = "1.18.0"
  timeout          = 600

  values = [
    file("${path.module}/airflow-minimal/airflow-minimal-values.yaml")
  ]
}
