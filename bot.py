import asyncio
import logging
from aiogram import Bot, Dispatcher, types
from aiogram.types import BotCommand
from aiogram.webhook.aiohttp_server import SimpleRequestHandler, setup_application
from aiogram.filters import Command
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
