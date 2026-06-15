import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    SQLALCHEMY_DATABASE_URI = os.getenv(
        "DATABASE_URL",
        "postgresql+pg8000://hubarena_user:hubarena_pass@localhost:5432/hubarena_db"
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    JSON_SORT_KEYS = False

    RABBITMQ_URL = os.getenv(
        "RABBITMQ_URL",
        "amqp://hubarena:hubarena_pass@localhost:5672/"
    )

    RABBITMQ_RESERVATION_QUEUE = os.getenv(
        "RABBITMQ_RESERVATION_QUEUE",
        "hubarena.reservations.events"
    )
