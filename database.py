import sqlite3

DB_PATH = "database.db"

def init_db():
    """Создаёт таблицы, если их нет."""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Таблица пользователей
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY,
            username TEXT,
            current_lesson INTEGER DEFAULT 1
        )
    """)

    # Таблица уроков
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS lessons (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            content TEXT NOT NULL,
            image TEXT DEFAULT NULL
        )
    """)

    # Таблица прогресса пользователей
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
    print("✅ База данных обновлена!")

if __name__ == "__main__":
    init_db()

def add_test_lessons():
    """Добавляет тестовые уроки в базу данных."""
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    lessons = [
        ("Введение в групповую терапию", "Групповая терапия - это процесс...", "lesson1.jpg"),
        ("Динамика группового общения", "Как люди взаимодействуют в группе?", "lesson2.jpg"),
        ("Этапы группового развития", "Группы проходят несколько стадий...", "lesson3.jpg")
    ]

    cursor.executemany("INSERT INTO lessons (title, content, image) VALUES (?, ?, ?)", lessons)
    conn.commit()
    conn.close()
    print("✅ Тестовые уроки добавлены!")

if __name__ == "__main__":
    add_test_lessons()
