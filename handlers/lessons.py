import sqlite3
import logging
from aiogram import Router, types, F
from aiogram.filters import Command
from aiogram.types import ReplyKeyboardMarkup, KeyboardButton
import config

router = Router()

def get_lesson(user_id):
    conn = sqlite3.connect("database.db")
    cursor = conn.cursor()

    cursor.execute("SELECT current_lesson FROM users WHERE id = ?", (user_id,))
    row = cursor.fetchone()

    if row:
        lesson_id = row[0]
    else:
        cursor.execute("INSERT INTO users (id, current_lesson) VALUES (?, 1)", (user_id,))
        conn.commit()
        lesson_id = 1

    cursor.execute("SELECT title, content, image FROM lessons WHERE id = ?", (lesson_id,))
    lesson = cursor.fetchone()
    
    conn.close()
    
    if lesson:
        return lesson_id, lesson[0], lesson[1], lesson[2]
    else:
        return None

@router.message(Command("lesson"))  # Используем правильный способ регистрации команды
async def send_lesson(message: types.Message):
    user_id = message.from_user.id
    lesson = get_lesson(user_id)

    if lesson:
        lesson_id, title, content, image = lesson
        keyboard = ReplyKeyboardMarkup(
            keyboard=[
                [KeyboardButton(text="⬅️ Назад"), KeyboardButton(text="➡️ Далее")],
                [KeyboardButton(text="📜 Меню")]
            ],
            resize_keyboard=True
        )

        response = f"📖 *{title}*\n\n{content}"
        
        if image:
            await message.answer_photo(photo=image, caption=response, reply_markup=keyboard, parse_mode="Markdown")
        else:
            await message.answer(response, reply_markup=keyboard, parse_mode="Markdown")
    else:
        await message.answer("❌ Урок не найден. Попробуйте позже.")
