#!/bin/bash

# ==========================================
# Скрипт установки Docker и Docker Compose
# ==========================================

# Остановить скрипт при первой ошибке
set -e

# Проверка: запущен ли скрипт от root
if [ "$EUID" -ne 0 ]; then
  echo "❌ Ошибка: Запустите скрипт с правами sudo: sudo ./setup.sh"
  exit 1
fi

echo "🚀 Начинаем установку Docker..."

# 1. Обновление системы
echo "🔄 Обновляем систему..."
apt update && apt upgrade -y

# 2. Установка зависимостей
echo "📦 Устанавливаем зависимости..."
apt install -y ca-certificates gnupg curl

# 3. Добавление GPG-ключа Docker
echo "🔑 Добавляем GPG-ключ Docker..."
install -m 0755 -d /usr/share/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor --yes -o /usr/share/keyrings/docker.gpg
chmod a+r /usr/share/keyrings/docker.gpg

# 4. Добавление репозитория Docker
echo "📋 Добавляем репозиторий Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Установка Docker
echo "🐳 Устанавливаем Docker..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin

# 6. Установка Docker Compose
echo "🐙 Устанавливаем Docker Compose..."
mkdir -p /usr/local/lib/docker/cli-plugins/
curl -fsSL https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Проверка: запускаем ли мы от имени обычного пользователя (не root)
if [ -n "$SUDO_USER" ]; then
    echo "👤 Добавляем пользователя $SUDO_USER в группу docker..."
    usermod -aG docker "$SUDO_USER"
    echo "✅ Готово! Перелогиньтесь или выполните 'newgrp docker' для применения изменений."
else
    echo "⚠️  Скрипт запущен напрямую от root, пропускаем добавление в группу docker."
fi

# 7. Финальная проверка
echo "✅ Установка завершена!"
docker --version
docker compose version
