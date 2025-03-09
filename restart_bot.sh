#!/bin/bash

echo "🚀 Перезапускаем бота..."

# Убиваем старый процесс (если он есть)
BOT_PROCESS=$(ps aux | grep python | grep bot.py | awk '{print $2}')
if [ -n "$BOT_PROCESS" ]; then
    echo "🛑 Завершаем старый процесс бота (PID: $BOT_PROCESS)..."
    kill -9 $BOT_PROCESS
fi

# Запускаем бота и пишем логи
echo "🚀 Запускаем нового бота..."
cd ~/professor_y_bot
nohup python bot.py > bot.log 2>&1 &

echo "✅ Бот запущен в фоне!"
