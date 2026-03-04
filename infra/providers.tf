provider "aws" {
  region     = var.region
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}