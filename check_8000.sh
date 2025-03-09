#!/bin/bash

echo "🔍 Проверяем порт 8000..."

# Проверяем, слушает ли что-то порт 8000
PORT_8000_PROCESS=$(sudo ss -tlnp | grep ":8000")

if [ -n "$PORT_8000_PROCESS" ]; then
    echo "✅ Порт 8000 используется процессом:"
    echo "$PORT_8000_PROCESS"
else
    echo "❌ Порт 8000 НЕ слушает. Бот не запущен!"
fi

# Проверяем, запущен ли бот
echo "📌 Проверяем процессы Python (Aiogram бот)..."
ps aux | grep python | grep bot.py

# Проверяем веб-сервисы
echo "📌 Какие сервисы слушают порты?"
sudo netstat -tulpn | grep LISTEN

echo "✅ Проверка завершена!"
