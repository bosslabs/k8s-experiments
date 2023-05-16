
terraform {
  required_version = ">= 1.4"
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.20.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }
    argocd = {
      source = "oboukili/argocd"
      version = "5.3.0"
    }
    time = {
      source = "hashicorp/time"
      version = "0.9.1"
    }
  }
}

provider "kubernetes" {
    config_path = "~/.kube/config"
    config_context = "kind-k8s-experiments"
}

provider "helm" {
    kubernetes {
        config_path = "~/.kube/config"
        config_context = "kind-k8s-experiments"
    }
}

provider "argocd" {
  username                  = "admin"
  password                  = "admin"
  port_forward_with_namespace = "argo"
  kubernetes {
    config_context = "kind-k8s-experiments"
  }
}

provider "time" {}