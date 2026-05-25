import pika

from app.config.config import Config


class RabbitMQClient:
    @staticmethod
    def get_connection():
        parameters = pika.URLParameters(Config.RABBITMQ_URL)
        return pika.BlockingConnection(parameters)

    @staticmethod
    def declare_reservation_queue():
        connection = RabbitMQClient.get_connection()
        channel = connection.channel()

        channel.queue_declare(
            queue=Config.RABBITMQ_RESERVATION_QUEUE,
            durable=True
        )

        connection.close()

        return Config.RABBITMQ_RESERVATION_QUEUE
