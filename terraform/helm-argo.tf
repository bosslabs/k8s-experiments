resource "helm_release" "argo_workflows" {
  chart = "argo-workflows"
  repository = "https://argoproj.github.io/argo-helm"

  namespace = kubernetes_namespace.argo.id
  name = "argo-workflows"

  set {
    name = "server.extraArgs[0]"
    value = "--auth-mode=server"
  }
  set {
    name = "singleNamespace"
    value = false
  }
  set {
    name = "workflow.serviceAccount.create"
    value = true
  }
}

resource "helm_release" "argo_cd" {
  chart = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"

  namespace = kubernetes_namespace.argo.id
  name = "argo-cd"

  set {
    name = "global.deploymentStrategy.type"
    value = "Recreate"
  }
}

resource "helm_release" "argo_events" {
  chart = "argo-events"
  repository = "https://argoproj.github.io/argo-helm"

  namespace = kubernetes_namespace.argo.id
  name = "argo-events"
}

resource "helm_release" "argo_apps" {
  chart = "argocd-apps"
  repository = "https://argoproj.github.io/argo-helm"

  namespace = kubernetes_namespace.argo.id
  name = "argocd-apps"
}

data "kubernetes_secret" "argocd_initial_admin_password" {
  metadata {
    name = "argocd-initial-admin-secret"
    namespace = kubernetes_namespace.argo.id
  }
}

output "argocd_initial_admin_password" {
  sensitive = true
  value = data.kubernetes_secret.argocd_initial_admin_password.data["password"]
}