
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