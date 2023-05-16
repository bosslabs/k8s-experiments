resource "kubernetes_namespace" "argo" {
    metadata {
        name = "argo"
        labels = {
            istio-injection = "enabled"
        }
    }
}

resource "kubernetes_namespace" "istio" {
    metadata {
        name = "istio-system"
    }
}

resource "kubernetes_namespace" "istio_ingress" {
    metadata {
        name = "istio-ingress"
        labels = {
            istio-injection = "enabled"
        }
    }
}