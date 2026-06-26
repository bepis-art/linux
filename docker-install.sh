#!/bin/bash
#Скрипт для установки Docker, Docker Compose и установления всех зависимостей

# Установка дополнительных плагинов
apt update  
apt upgrade
apt install ca-certificates gnupg curl

# Установка Docker
# GPG-ключ, который будет использоваться пакетным менеджером apt для проверки подлинности пакетов из репозитория Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt update
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin

# Установка Docker Compose
mkdir -p /usr/local/lib/docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
