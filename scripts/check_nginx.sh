#!/bin/bash

LOG="/var/log/check_nginx.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://localhost)

if [ "$HTTP_CODE" != "200" ]; then
    echo "[$TIMESTAMP] WARN: Nginx не отвечает (код: $HTTP_CODE). Перезапуск..." >> "$LOG"
    systemctl restart nginx
    sleep 3
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" --max-time 5 http://localhost)
    if [ "$HTTP_CODE" = "200" ]; then
        echo "[$TIMESTAMP] OK: Nginx востановлен." >> "$LOG"
    else
        echo "[$TIMESTAMP] CRIT: Ngixn не поднялся!" >> "$LOG"
    fi
else
    echo "[$TIMESTAMP] OK: Nginx работает (код: $HTTP_CODE)." >> "$LOG"