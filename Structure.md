/home/goddim/devops-diplom-yandexcloud
├── Dockerfile                # Инструкции для сборки Docker-образа.
├── README.md                 # Описание проекта и инструкций по использованию.
├── step by step.md           # Пошаговое руководство по настройке или использованию.
├── Structure.md              # Описание структуры проекта или архитектуры.
├── kubespray
│   ├── .github               # Конфигурации для GitHub Actions.
│   ├── .gitlab-ci            # Конфигурации CI/CD для GitLab.
│   ├── contrib               # Вспомогательные скрипты или файлы.
│   ├── docs                  # Документация проекта.
│   ├── extra_playbooks       # Дополнительные Ansible playbooks.
│   ├── inventory             # Инвентарь для Ansible.
│   ├── library               # Библиотеки для Ansible.
│   ├── logo                  # Логотипы и изображения.
│   ├── meta                  # Метаданные и настройки.
│   ├── playbooks             # Основные Ansible playbooks.
│   ├── plugins               # Плагины для Ansible.
│   ├── roles                 # Роли Ansible для управления инфраструктурой.
│   ├── scripts               # Скрипты для автоматизации.
│   ├── test-infra            # Тесты для инфраструктуры.
│   ├── tests                 # Тесты для развертывания.
│   ├── _config.yml           # Основной конфигурационный файл.
│   ├── .ansible-lint         # Конфигурация для проверки кода с помощью Ansible Lint.
│   ├── .gitmodules           # Информация о субмодулях Git.
│   ├── ansible.cfg           # Конфигурация Ansible.
│   ├── CHANGELOG.md          # История изменений проекта.
│   ├── cluster.yml           # Основной файл для развертывания Kubernetes.
│   ├── Dockerfile            # Dockerfile для создания образа.
│   ├── galaxy.yml            # Описание Ansible коллекции.
│   ├── LICENSE               # Лицензия проекта.
│   ├── Makefile              # Makefile для автоматизации задач.
│   ├── OWNERS                # Информация о владельцах проекта.
│   ├── README.md             # Описание проекта Kubespray.
│   ├── Vagrantfile           # Конфигурация для Vagrant.
│   └── upgrade-cluster.yml   # Плейбук для обновления кластера.
├── terraform
│   ├── .terraform            # Директория для плагинов и зависимостей Terraform.
│   ├── bucket                # Конфигурация для создания и настройки бакетов в Yandex Cloud.
│   │   ├── .terraform        # Зависимости Terraform для работы с бакетами.
│   │   ├── .terraform.lock.hcl  # Файл блокировки для Terraform.
│   │   ├── bucket.tf         # Конфигурация для бакета.
│   │   ├── provider.tf       # Конфигурация провайдера для Terraform.
│   │   ├── terraform.tfstate # Файл состояния Terraform.
│   │   ├── terraform.tfvars  # Переменные для Terraform.
│   │   └── variables.tf      # Определение переменных для Terraform.
│   ├── ansible.cfg           # Конфигурация для Ansible.
│   ├── network.tf            # Конфигурация для создания сети в облаке.
│   ├── provider.tf           # Определение провайдера для Terraform (например, Yandex Cloud).
│   ├── terraform.tfstate     # Файл состояния Terraform.
│   ├── terraform.tfvars      # Переменные для Terraform.
│   └── variables.tf          # Дополнительные переменные для Terraform.
└── .gitignore                # Список файлов и директорий, игнорируемых Git.
