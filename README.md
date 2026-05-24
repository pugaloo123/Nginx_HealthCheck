# Nginx Health Check

Скрипт автоматической проверки здоровья Nginx + перезапуск при падении.
Запускается каждую минуту через systemd timer.

## Как работает

1. Каждую минуту таймер запускает `check_nginx.sh`
2. Скрипт делает HTTP-запрос на `localhost`
3. Если ответ не `200` — перезапускает Nginx и пишет в лог
4. Все события записываются в `/var/log/check_nginx.log`

## Требования

- Ubuntu / Debian
- systemd
- curl

## Установка

```bash
git clone https://github.com/pugaloo123/Nginx_HealthCheck.git
cd Nginx_HealthCheck
chmod +x install.sh
sudo ./install.sh
```

## Запуск

После установки таймер запускается автоматически. Если нужно управлять вручную:

```bash
# Запустить проверку прямо сейчас
sudo systemctl start check-nginx.service

# Остановить таймер
sudo systemctl stop check-nginx.timer

# Запустить таймер снова
sudo systemctl start check-nginx.timer
```

## Проверка

```bash
# Статус таймера
systemctl status check-nginx.timer

# Когда следующий запуск
systemctl list-timers check-nginx.timer

# Следить за логом
tail -f /var/log/check_nginx.log
```

## Тест аварии

Останавливаем Nginx вручную и ждём минуту:

```bash
sudo systemctl stop nginx
tail -f /var/log/check_nginx.log
```

Скрипт обнаружит падение и автоматически поднимет сервис.

## Структура проекта

```
Nginx_HealthCheck/
├── install.sh              # установка одной командой
├── scripts/
│   └── check_nginx.sh      # скрипт проверки
└── systemd/
    ├── check-nginx.service # описание задачи
    └── check-nginx.timer   # расписание запуска
```