#!/bin/bash

echo "🔍 Проверяем логи бота..."

# Показываем последние 50 строк логов
tail -n 50 ~/professor_y_bot/bot.log

echo "✅ Проверка завершена!"
