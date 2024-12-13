terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.134.0"
    }
  }
}

provider "yandex" {
#  service_account_key_file = "key.json"
  token     = var.oauth_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.a-zone
}