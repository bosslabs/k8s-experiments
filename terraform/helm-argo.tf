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

  set {
    name = "configs.secret.argocdServerAdminPassword"
    value = "$2y$10$jHApD9yjeGoLjx3DSd.bJujp3qSnFdFTHt5dn1mVLnybrqRvNjkzO" //admin
  }

  set {
    name = "configs.secret.argocdServerAdminPasswordMtime"
    value = "2021-01-01T10:11:12Z"
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