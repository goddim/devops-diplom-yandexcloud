devops-diplom-yandexcloud/
├── terraform/
│   ├── backend/
│   │   ├── main.tf                  # Конфигурация для backend и создания S3-бакета
│   │   ├── variables.tf             # Определение переменных
│   │   ├── backend.config           # Конфигурация для S3 backend
│   │   ├── terraform.tfvars         # Значения переменных
│   │   ├── outputs.tf               # Определение выводов (опционально)
│   │   └── .terraform/              # Локальные файлы Terraform (автоматически создаются)
│   │       ├── providers/           # Кэшированные плагины провайдеров
│   │       └── terraform.tfstate    # Локальное состояние Terraform
│   ├── auth/
│   │   ├── main.tf                  # Конфигурация для сервисных аккаунтов и ролей
│   │   ├── variables.tf             # Определение переменных
│   │   ├── terraform.tfvars         # Значения переменных
│   │   └── outputs.tf               # Определение выводов
│   └── infra/
│       ├── main.tf                  # Основная инфраструктура (если используется)
│       ├── variables.tf             # Определение переменных
│       ├── terraform.tfvars         # Значения переменных
│       └── outputs.tf               # Определение выводов
├── README.md                        # Документация проекта (опционально)
└── .gitignore                       # Исключение файлов для Git

Пояснения:
backend/ – Каталог для настройки S3 backend и хранения состояния Terraform.
auth/ – Конфигурация для работы с сервисными аккаунтами, ролями и правами доступа.
infra/ – Основная инфраструктура, например, виртуальные машины, сети, базы данных и т. д.
.terraform/ – Временные файлы Terraform, не включайте их в систему контроля версий.
terraform.tfvars – Хранит значения переменных для использования в конфигурациях Terraform.

1 Шаг. создание сервисного каталога с ролями и создание бакета
cd /home/goddim/devops-diplom-yandexcloud/terraform/bucket
запускаем
terraform init
terraform apply 




2 Шаг. создание сетей подсетей и нод
cd /home/goddim/devops-diplom-yandexcloud/03-preparation-yc
Если есть проблема с доступом проверяем ключи, то создаем ключи c yc iam access-key create --service-account-name=sa
 и вносим их в backend.key и в раздел


_________________________________

3. Создание кластера
cd /home/goddim/devops-diplom-yandexcloud/kubespray
ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b

для тестирования нод заходим на мастер ноду: 
sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl get nodes
sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl get pods --all-namespaces

5. Подготовка cистемы мониторинга и деплой приложения

- загрузка и настроика Helm (интурумент  для управления пакетами в Kubernetes.)
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

- Создаем namespace monitoring (Пространство имен (namespace) используется для изоляции ресурсов Kubernetes)
kubectl create namespace monitoring

- Добавили репозиторий prometheus-community (Репозиторий содержит чарт kube-prometheus-stack, который развертывает набор инструментов мониторинга, включая Prometheus и Grafana.)
sudo helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

- разворачиваем kube-prometheus-stack
sudo helm install stable prometheus-community/kube-prometheus-stack --namespace=monitoring

- проверяем состояние ресурсов
kubectl get all -n monitoring