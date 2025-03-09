#!/bin/bash

echo "🚀 Исправляем конфликт порта 443..."

# 1️⃣ Определяем процесс, который занимает порт 443
PORT_PROCESS=$(sudo ss -tlnp | grep ":443" | awk '{print $7}' | cut -d',' -f2 | cut -d'=' -f2)

if [ -n "$PORT_PROCESS" ]; then
    echo "❌ Порт 443 занят процессом с PID: $PORT_PROCESS"
    
    # 2️⃣ Останавливаем процесс, если это не Nginx
    if ps -p $PORT_PROCESS -o comm= | grep -q "nginx"; then
        echo "✅ Nginx занимает порт 443, перезапускаем его..."
        sudo systemctl restart nginx
    else
        echo "🛑 Завершаем процесс, который использует порт 443..."
        sudo kill -9 $PORT_PROCESS
    fi
else
    echo "✅ Порт 443 свободен."
fi

# 3️⃣ Проверяем, остался ли процесс на 443 порту
sudo ss -tlnp | grep ":443" || echo "✅ Порт 443 теперь свободен."

echo "🚀 Пробуем перезапустить бота..."
cd ~/professor_y_bot
python bot.py
