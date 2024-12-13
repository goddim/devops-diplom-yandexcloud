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

variable "key" {
  description = "Ключ для хранения состояния Terraform"
  type        = string
}

variable "folder_id" {
  description = "ID folder"
  type        = string
}


variable "a-zone" {
  default = "ru-central1-a"
}
