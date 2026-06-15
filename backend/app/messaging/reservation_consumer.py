import json
import time

import pika

from app.config.config import Config


class ReservationConsumer:

    @staticmethod
    def process_reservation_created(event):
        payload = event.get("payload", {})

        print("[ReservationConsumer] Nova reserva recebida.")
        print(f"[ReservationConsumer] Reserva ID: {payload.get('id')}")
        print(f"[ReservationConsumer] Cliente ID: {payload.get('clientId')}")
        print(f"[ReservationConsumer] Quadra ID: {payload.get('courtId')}")
        print(f"[ReservationConsumer] Data: {payload.get('date')}")
        print(f"[ReservationConsumer] Horário: {payload.get('startTime')} - {payload.get('endTime')}")
        print("[ReservationConsumer] Ação simulada: notificar prestador sobre nova reserva.")

    @staticmethod
    def process_reservation_status_changed(event):
        payload = event.get("payload", {})
        reservation = payload.get("reservation", {})

        print("[ReservationConsumer] Alteração de status recebida.")
        print(f"[ReservationConsumer] Reserva ID: {reservation.get('id')}")
        print(f"[ReservationConsumer] Status anterior: {payload.get('previousStatus')}")
        print(f"[ReservationConsumer] Novo status: {payload.get('newStatus')}")
        print("[ReservationConsumer] Ação simulada: notificar cliente sobre mudança de status.")

    @staticmethod
    def callback(channel, method, properties, body):
        try:
            event = json.loads(body.decode("utf-8"))
            event_name = event.get("event")

            print("\n==================================================")
            print(f"[ReservationConsumer] Evento recebido: {event_name}")
            print(f"[ReservationConsumer] Produtor: {event.get('producer')}")
            print(f"[ReservationConsumer] Ocorrido em: {event.get('occurredAt')}")
            print("==================================================")

            if event_name == "reservation.created":
                ReservationConsumer.process_reservation_created(event)

            elif event_name == "reservation.status_changed":
                ReservationConsumer.process_reservation_status_changed(event)

            else:
                print(f"[ReservationConsumer] Evento desconhecido ignorado: {event_name}")

            time.sleep(1)

            channel.basic_ack(delivery_tag=method.delivery_tag)
            print("[ReservationConsumer] Mensagem processada e confirmada com ACK.")

        except Exception as error:
            print(f"[ReservationConsumer] Erro ao processar mensagem: {error}")
            channel.basic_nack(
                delivery_tag=method.delivery_tag,
                requeue=False
            )

    @staticmethod
    def start():
        connection = pika.BlockingConnection(
            pika.URLParameters(Config.RABBITMQ_URL)
        )

        channel = connection.channel()

        channel.queue_declare(
            queue=Config.RABBITMQ_RESERVATION_QUEUE,
            durable=True
        )

        channel.basic_qos(prefetch_count=1)

        channel.basic_consume(
            queue=Config.RABBITMQ_RESERVATION_QUEUE,
            on_message_callback=ReservationConsumer.callback
        )

        print("[ReservationConsumer] Consumidor iniciado.")
        print(f"[ReservationConsumer] Aguardando eventos na fila: {Config.RABBITMQ_RESERVATION_QUEUE}")
        print("[ReservationConsumer] Pressione CTRL+C para encerrar.")

        try:
            channel.start_consuming()
        except KeyboardInterrupt:
            print("\n[ReservationConsumer] Encerrando consumidor...")
            channel.stop_consuming()
            connection.close()


if __name__ == "__main__":
    ReservationConsumer.start()
