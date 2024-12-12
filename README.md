# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
  ![image](https://github.com/user-attachments/assets/4a59d06e-c7c7-4113-874b-6dbf17025fb2)

2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)
   ![image](https://github.com/user-attachments/assets/c04918cc-2d51-40a3-84cf-8b656a322879)

4. Создайте конфигурацию Terrafrom, используя созданный бакет ранее как бекенд для хранения стейт файла. Конфигурации Terraform для создания сервисного аккаунта и бакета и основной инфраструктуры следует сохранить в разных папках.
   ![image](https://github.com/user-attachments/assets/6b2dfeae-965c-4957-9352-c9f546a72e2b)

6. Создайте VPC с подсетями в разных зонах доступности.
   ![image](https://github.com/user-attachments/assets/b92cf3ae-ba36-4efc-a3f1-6c543b974ea4)

8. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
9. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.
![image](https://github.com/user-attachments/assets/db8d4452-e859-454e-bced-66443d655517)
![image](https://github.com/user-attachments/assets/a3e71816-254e-4488-8f38-4a5ab887b373)

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий, стейт основной конфигурации сохраняется в бакете или Terraform Cloud
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:
![image](https://github.com/user-attachments/assets/13f462e1-5506-4600-ba8f-641bfefe593c)
1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. ![image](https://github.com/user-attachments/assets/de48afac-aab3-4649-8a98-cfb5d1f5b985)

4. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.
![image](https://github.com/user-attachments/assets/a2f357a9-6c96-4ddd-8e1f-5c495ed5eaf3)
![image](https://github.com/user-attachments/assets/46cd560a-3f90-4626-b9d8-2a52b3c5d1d8)

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

мой собранный обаз
![image](https://github.com/user-attachments/assets/372f0920-3c6e-4477-a49b-c588f65d21e6)
образ загружен
![image](https://github.com/user-attachments/assets/78e1845c-eeea-4059-898f-8c66a11833f4)

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным [docker image](https://hub.docker.com/repository/docker/goddim1979/test-app/general). В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользоваться пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). Альтернативный вариант - использовать набор helm чартов от [bitnami](https://github.com/bitnami/charts/tree/main/bitnami).

2. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ на 80 порту к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ на 80 порту к тестовому приложению.
---
Подготовка cистемы мониторинга
![image](https://github.com/user-attachments/assets/c1b9d4bb-8cb3-4cac-9a4b-11f0c93231c2)
![image](https://github.com/user-attachments/assets/c2a41a50-45b6-43b2-884f-edf6266c29fc)

Http доступ к web интерфейсу grafana.
Чтобы подключаться к серверу извне перенастроим сервисы(svc)
![image](https://github.com/user-attachments/assets/df846540-be30-48d9-b211-deaad7397e3a)

Дашборды в grafana отображающие состояние Kubernetes кластера.
![image](https://github.com/user-attachments/assets/68c425e8-0130-4c1e-bfe7-35dcad24026f)
![image](https://github.com/user-attachments/assets/8dc2f3aa-fdfa-48cf-9c97-735af5974cb0)

![image](https://github.com/user-attachments/assets/8ee35364-930f-435f-9697-087f6473dc10)
![image](https://github.com/user-attachments/assets/b70a7ba3-3f8b-4a00-8f90-50891737c78b)


### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Для автоматической сборки docker image и деплоя приложения при изменении кода буду использовать Github actions

Для работы ci-cd в github action требуются учетные данные:

- в DockerHub создаем Access Token (github-actions)

 - Затем создаем в github секреты для доступа к DockerHub.
   
DOCKERHUB_USERNAME-goddim1979

DOCKERHUB_TOKEN — github-actions

KUBE_CONFIG_DATA — закодированные в Base64 данные конфигурации - cat ~/.kube/config | base64 -w 0


Ожидаемый результат:
1. Интерфейс ci/cd сервиса доступен по http.
   ![image](https://github.com/user-attachments/assets/f5056ab0-3e5d-4106-a9fd-a034e7ab3e6e)

3. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
 ci-cd.yml
```name: CI/CD Pipeline

on:
  push:
    branches:
      - main
    tags:
      - 'v*'
  pull_request:
    branches:
      - main

env:
  IMAGE_TAG: goddim1979/test-app
  RELEASE_NAME: test-app
  NAMESPACE: default

jobs:
  build-and-push:
    name: Build and Push Docker Image
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Log in to DockerHub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Extract Version from Commit Message
        id: extract-version
        run: |
          VERSION=$(echo "${{ github.event.head_commit.message }}" | sed -E 's/[^a-zA-Z0-9._-]/_/g')
          if [[ ! -z "$VERSION" ]]; then
            echo "VERSION=${VERSION}" >> $GITHUB_ENV
          else
            echo "VERSION=latest" >> $GITHUB_ENV
          fi

      - name: Build and Push Docker Image
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: ${{ env.IMAGE_TAG }}:${{ github.ref_name }}  # Используем имя тега из Git

  deploy:
    needs: build-and-push
    name: Deploy to Kubernetes
    if: startsWith(github.ref, 'refs/heads/main') || startsWith(github.ref, 'refs/tags/v')
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Authenticate to Kubernetes Cluster
        env:
          KUBE_CONFIG_DATA: ${{ secrets.KUBE_CONFIG_DATA }}
        run: |
          mkdir -p $HOME/.kube
          echo "$KUBE_CONFIG_DATA" | base64 --decode > $HOME/.kube/config

      - name: Extract Version from Commit Message
        id: extract-version
        run: |
          VERSION=$(echo "${{ github.event.head_commit.message }}" | sed -E 's/[^a-zA-Z0-9._-]/_/g')
          if [[ ! -z "$VERSION" ]]; then
            echo "VERSION=${VERSION}" >> $GITHUB_ENV
          else
            echo "VERSION=latest" >> $GITHUB_ENV
          fi

      - name: Replace Image Tag in Kubernetes Manifests
        run: |
          sed -i "s|image: goddim1979/test-app:.*|image: ${{ env.IMAGE_TAG }}:${{ github.ref_name }}|" ./test-app/deploy.yaml

      - name: Apply Kubernetes Manifests
        run: |
          kubectl apply -f ./test-app/deploy.yaml

```


3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.
![image](https://github.com/user-attachments/assets/3d4f4e67-8191-4b3f-b010-2a67453c4570)
![image](https://github.com/user-attachments/assets/65c292bb-ea45-460f-8378-a241080f0276)
![image](https://github.com/user-attachments/assets/7509b543-e86a-4200-be6e-1a474a328a8e)

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)

