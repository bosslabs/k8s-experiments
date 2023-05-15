resource "argocd_application" "ingress_nginx" {
  metadata {
    name      = "ingress-nginx"
    namespace = "argo"
    labels = {
      managed = "Terraform"
    }
  }

  cascade = false # disable cascading deletion
  wait    = true

  spec {
    project = "default"

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "kube-system"
    }

    source {
      repo_url        = "https://github.com/bosslabs/k8s-experiments"
      path            = "argo/utilities/ingress-nginx"
      target_revision = "main"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      # Only available from ArgoCD 1.5.0 onwards
      sync_options = ["Validate=false"]
      retry {
        limit = "5"
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}