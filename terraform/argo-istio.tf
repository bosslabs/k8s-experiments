resource "time_sleep" "wait_for_argo" {
  depends_on = [
    helm_release.argo_cd,
    helm_release.argo_apps
  ]

  create_duration = "10s"
}

resource "argocd_application" "istio" {
  depends_on = [time_sleep.wait_for_argo]
  metadata {
    name      = "istio-base"
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
      namespace = kubernetes_namespace.istio.id
    }

    source {
      chart           = "base"
      repo_url        = "https://istio-release.storage.googleapis.com/charts"
      target_revision = "1.17.2"
      helm {
        release_name = "istio-base"
      }
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

resource "argocd_application" "istiod" {
  depends_on = [time_sleep.wait_for_argo]
  metadata {
    name      = "istiod"
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
      namespace = kubernetes_namespace.istio.id
    }

    source {
      chart           = "istiod"
      repo_url        = "https://istio-release.storage.googleapis.com/charts"
      target_revision = "1.17.2"
      helm {
        release_name = "istiod"
      }
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

resource "argocd_application" "istio_gateway" {
  depends_on = [
    time_sleep.wait_for_argo,
    argocd_application.istio,
    argocd_application.istiod
  ]
  metadata {
    name      = "istio-gateway"
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
      namespace = kubernetes_namespace.istio_ingress.id
    }

    source {
      chart           = "gateway"
      repo_url        = "https://istio-release.storage.googleapis.com/charts"
      target_revision = "1.17.2"
      helm {
        release_name = "istio-gateway"

        parameter {
          name  = "service.type"
          value = "NodePort"
        }
      }
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

resource "argocd_application" "kiali" {
  depends_on = [
    time_sleep.wait_for_argo,
    argocd_application.istio,
    argocd_application.istiod,
    argocd_application.istio_gateway
  ]
  metadata {
    name      = "kiali"
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
      namespace = kubernetes_namespace.istio.id
    }

    source {
      chart           = "kiali-server"
      repo_url        = "https://kiali.org/helm-charts"
      target_revision = "1.68.0"
      helm {
        release_name = "kiali"
      }
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