#!/bin/bash

set -e

echo 'Установка Nginx Health Check'

if [ "$EUID" -ne 0 ]; then
    echo "Запустить от root: sudo ./install.sh"
    exit 1
fi

if ! command -v nginx &> /dev/null; then
    echo "Nginx не найден, устанавливаем ..."
    apt update && apt install -y nginx
    systemctl enable --now nginx
    systemctl enable --now nginx
    echo "Nginx установлен."
fi

echo "Копируем check_ngin.sh ..."
cp scripts/check_nginx.sh /usr/local/bin/check_nginx.sh
chmod +x /usr/local/bin/check_nginx.sh

echo "Копируем systemd unit-файлы..."
cp systemd/check-nginx.service /etc/systemd/system/
cp system/check-nginx.timer /etc/systemd/system/

echo ""
echo "Готово!"
echo "Статус таймера: systemctl status check-nginx.timer"
echo "Следить за логом: tail -f /var/log/check_nginx.log

