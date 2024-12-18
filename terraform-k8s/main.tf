terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

# Provider configuration for Kubernetes
provider "kubernetes" {
  config_path = "~/.kube/config"   # Path to the kubeconfig file
  config_context = "minikube"      # Specify the Minikube context
}

# Example: Creating a namespace
resource "kubernetes_namespace" "example" {
  metadata {
    name = "terraform-namespace"
  }
}

# Example: Creating a deployment
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-deployment"
    namespace = kubernetes_namespace.example.metadata[0].name
    labels = {
      app = "nginx"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# Example: Creating a service
resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
    namespace = kubernetes_namespace.example.metadata[0].name
  }

  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}
