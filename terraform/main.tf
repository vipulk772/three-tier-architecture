provider "azurerm" {
    features {}
}

variable "subscription_id" {
    description = "azure subscription id"
}

variable "client_id" {
    description = "azure sp client id"
}

variable "tenant_id" {
    description = "azure sp tenant id"
}

variable "resource_group" {
    description = "azure resource_group name"
}

variable "k8sname" {
  description = "value"
  type = map(string)

  default = {
    "dev" = "k8s-dev"
    "prod" = "k8s-prod"
  }
}

module "AKS_cluster"{
    source = "./modules/akscluster"
    subscription_id= var.subscription_id
    client_id= var.client_id
    tenant_id= var.tenant_id
    resource_group= var.resource_group
    k8sname = lookup(var.k8sname, terraform.workspace, "k8s-dev")
}

terraform {

  backend "azurerm" {
      resource_group_name  = "devops"
      storage_account_name = "infradeploytfstate"
      container_name       = "infradeploytfstatecontainer"
      key                  = "terraform.tfstate"
  }

}
