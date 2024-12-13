variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  description = "ID облака Yandex"
  type        = string
}
variable "oauth_token" {
  description = "OAuth токен для доступа к Yandex.Cloud"
  type        = string
}

variable "endpoint" {
  description = "Yandex Cloud endpoint for Terraform backend"
  type        = string
  default     = "storage.yandexcloud.net" # Укажите значение по умолчанию или удалите default
}

variable "subnet-zones" {
  description = "Список зон для подсетей"
  type        = list(string)
}

variable "cidr" {
  description = "CIDR блоки для каждой подсети"
  type        = map(list(string))
}

variable "key" {
  description = "Ключ для хранения состояния Terraform"
  type        = string
}

variable "folder_id" {
  description = "ID folder"
  type        = string
}

variable "ubuntu-2004-lts" {
  description = "ID образа Ubuntu 20.04 LTS для виртуальной машины"
  type        = string
}

variable "a-zone" {
  default = "ru-central1-a"
}
