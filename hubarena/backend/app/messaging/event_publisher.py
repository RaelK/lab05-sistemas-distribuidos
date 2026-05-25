import json
from datetime import datetime, timezone

import pika

from app.config.config import Config


class EventPublisher:

    @staticmethod
    def publish(event_name, payload):
        connection = pika.BlockingConnection(
            pika.URLParameters(Config.RABBITMQ_URL)
        )

        channel = connection.channel()

        channel.queue_declare(
            queue=Config.RABBITMQ_RESERVATION_QUEUE,
            durable=True
        )

        event = {
            "event": event_name,
            "producer": "hubarena-backend",
            "occurredAt": datetime.now(timezone.utc).isoformat(),
            "payload": payload
        }

        channel.basic_publish(
            exchange="",
            routing_key=Config.RABBITMQ_RESERVATION_QUEUE,
            body=json.dumps(event, ensure_ascii=False),
            properties=pika.BasicProperties(
                delivery_mode=2,
                content_type="application/json"
            )
        )

        connection.close()

        print(f"[EventPublisher] Evento publicado: {event_name}")
