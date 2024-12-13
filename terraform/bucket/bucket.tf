// Create SA
resource "yandex_iam_service_account" "sa-terraform" {
    name      = "sa-terraform"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "terraform-editor" {
    folder_id = var.folder_id
    role      = "admin"
    member    = "serviceAccount:${yandex_iam_service_account.sa-terraform.id}"
    depends_on = [yandex_iam_service_account.sa-terraform]
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
    service_account_id = yandex_iam_service_account.sa-terraform.id
    description        = "static access key"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "netology-bucket" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = "yashkin-2024"
    acl    = "private"
    force_destroy = true
}


// Add "backendConf" to bucket
resource "yandex_storage_object" "object-1" {
    access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    bucket = yandex_storage_bucket.netology-bucket.bucket
    key = "terraform.tfstate"
    source = "./terraform.tfstate"
    acl    = "private"
    depends_on = [yandex_storage_bucket.netology-bucket]
}
