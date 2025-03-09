#!/bin/bash

echo "🚀 Начинаем настройку проекта Профессор Ю..."

# 1️⃣ Создание папки проекта
echo "📂 Создаём директорию проекта..."
mkdir -p ~/professor_y_bot
cd ~/professor_y_bot || exit

# 2️⃣ Создание виртуального окружения
echo "🐍 Создаём виртуальное окружение..."
python3 -m venv venv

# 3️⃣ Активация виртуального окружения
echo "✅ Активируем виртуальное окружение..."
source venv/bin/activate

# 4️⃣ Установка зависимостей
echo "📦 Устанавливаем зависимости..."
pip install --upgrade pip
pip install aiogram

# 5️⃣ Создание базы данных SQLite
echo "🛢️ Настраиваем базу данных..."
cat <<EOF > database.py
import sqlite3

DB_PATH = "database.db"

def init_db():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            username TEXT,
            current_lesson INTEGER DEFAULT 1
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS lessons (
            id INTEGER PRIMARY KEY,
            title TEXT,
            content TEXT,
            image TEXT,
            test TEXT
        )
    """)

    cursor.execute("""
        CREATE TABLE IF NOT EXISTS progress (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER,
            lesson_id INTEGER,
            completed BOOLEAN DEFAULT FALSE,
            FOREIGN KEY (user_id) REFERENCES users(id),
            FOREIGN KEY (lesson_id) REFERENCES lessons(id)
        )
    """)

    conn.commit()
    conn.close()
    print("✅ База данных успешно инициализирована!")

if __name__ == "__main__":
    init_db()
EOF

# 6️⃣ Запуск скрипта создания БД
echo "🛠️ Создаём таблицы в БД..."
python database.py

# 7️⃣ Проверка структуры БД
echo "🔍 Проверяем таблицы в БД..."
sqlite3 database.db "SELECT name FROM sqlite_master WHERE type='table';"

echo "✅ Проект Профессор Ю настроен!"
