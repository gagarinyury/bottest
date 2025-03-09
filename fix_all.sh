#!/bin/bash

echo "🚀 Исправляем файлы, права доступа и перезапускаем бота..."

# 1️⃣ Убеждаемся, что директория  существует
mkdir -p ~/professor_y_bot/handlers

# 2️⃣ Изменяем права доступа, если есть ошибки Permission Denied
chmod -R 755 ~/professor_y_bot/handlers

# 3️⃣ Перезаписываем 
cat > ~/professor_y_bot/handlers/lessons.py <<LSPY
import sqlite3
import logging
from aiogram import Router, types
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

@router.message(commands=["lesson"])
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

LSPY

echo "✅  исправлен!"

# 4️⃣ Перезаписываем 
cat > ~/professor_y_bot/bot.py <<BTPY
import asyncio
import logging
from aiogram import Bot, Dispatcher, types
from aiogram.types import BotCommand
from aiogram.webhook.aiohttp_server import SimpleRequestHandler, setup_application
from aiohttp import web
import config
from handlers.lessons import router as lessons_router

logging.basicConfig(level=logging.INFO)

bot = Bot(token=config.BOT_TOKEN)
dp = Dispatcher()

dp.include_router(lessons_router)

async def on_startup():
    await bot.set_webhook(url=config.WEBHOOK_URL)
    await bot.set_my_commands([BotCommand(command="lesson", description="Получить урок")])
    logging.info(f"🚀 Webhook установлен: {config.WEBHOOK_URL}")

app = web.Application()
SimpleRequestHandler(dispatcher=dp, bot=bot).register(app, path=config.WEBHOOK_PATH)
setup_application(app, dp, bot=bot, on_startup=on_startup)

if __name__ == "__main__":
    web.run_app(app, host="0.0.0.0", port=config.WEBHOOK_PORT)

BTPY

echo "✅  обновлён!"

# 5️⃣ Перезапуск бота с логированием ошибок
echo "🚀 Перезапускаем бота..."
cd ~/professor_y_bot
./restart_bot.sh

echo "✅ Бот исправлен и перезапущен!"
