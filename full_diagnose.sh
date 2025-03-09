#!/bin/bash

echo "🔍 Полная диагностика системы..."

# 1️⃣ Проверяем, какой Python используется
echo "📌 Python версии:"
which python
python --version

echo "📌 Активное виртуальное окружение:"
echo $VIRTUAL_ENV

# 2️⃣ Проверяем установленные библиотеки
echo "📌 Установленные библиотеки:"
pip list

# 3️⃣ Проверяем файлы и права доступа
echo "📌 Файлы и их права:"
ls -la ~/professor_y_bot/
ls -la ~/professor_y_bot/handlers/

# 4️⃣ Проверяем процессы Python (есть ли бот)
echo "📌 Запущенные процессы Python:"
ps aux | grep python

# 5️⃣ Проверяем, какие порты слушаются
echo "📌 Прослушиваемые порты:"
ss -tlnp

# 6️⃣ Проверяем, работает ли Nginx
echo "📌 Статус Nginx:"
systemctl status nginx | grep Active

echo "✅ Диагностика завершена!"
