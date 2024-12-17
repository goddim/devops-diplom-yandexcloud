#!/bin/bash

# Шаг 1: Запускаем terraform output и сохраняем результат в JSON
echo "Generating Terraform output..."
terraform output -json > output.json

# Проверяем, что output.json был создан
if [[ ! -f output.json ]]; then
    echo "Error: Terraform output failed to generate output.json."
    exit 1
fi

# Проверка наличия yq и jq
if ! command -v yq &> /dev/null; then
    echo "Error: yq is not installed. Install it first."
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Install it first."
    exit 1
fi

# Создаем директорию для инвентаря, если она не существует
inventory_dir="/home/goddim/devops-diplom-yandexcloud/kubespray/inventory/mycluster"
mkdir -p "$inventory_dir"

# Шаг 2: Генерируем Ansible inventory из output.json и конвертируем в YAML
echo "Generating Ansible inventory..."

jq -r '
{
  all: {
    hosts: (
      .external_ip_address_nodes.value | to_entries |
      map({
        (.key): {
          ansible_host: .value,
          ansible_user: "ubuntu"
        }
      }) | add
    ),
    children: {
      kube_control_plane: { hosts: { "node-0": null } },
      kube_node: { hosts: { "node-1": null, "node-2": null } },
      etcd: { hosts: { "node-0": null } },
      k8s_cluster: {
        children: {
          kube_control_plane: null,
          kube_node: null
        }
      }
    }
  }
}' output.json | yq -P > "$inventory_dir/hosts.yaml"

# Проверяем, что файл hosts.yaml был создан
if [[ -f "$inventory_dir/hosts.yaml" ]]; then
    echo "Ansible inventory successfully generated in $inventory_dir/hosts.yaml:"
    cat "$inventory_dir/hosts.yaml"
else
    echo "Error: Failed to generate $inventory_dir/hosts.yaml."
    exit 1
fi
