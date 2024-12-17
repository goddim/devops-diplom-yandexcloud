
1 Шаг. создание сервисного каталога с ролями и создание бакета
cd /home/goddim/devops-diplom-yandexcloud/terraform/bucket
запускаем
terraform init
terraform apply 




2 Шаг. подключение бакета для хранения состояни, создание сетей подсетей и нод

cd /home/goddim/devops-diplom-yandexcloud/terraform
terraform init -backend-config=./backend.key
terraform apply
2.5 Генерируем ansible playbook hosts.yaml из output терраформа.
Запускаем скрипт :
./generate-inventory.sh
------
предварительно проверяем установленно 
yq --version
jq --version

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