from datetime import date, time

from app.messaging.event_publisher import EventPublisher
from app.repositories.court_repository import CourtRepository
from app.repositories.reservation_repository import ReservationRepository
from app.repositories.user_repository import UserRepository


class ReservationService:

    @staticmethod
    def create_reservation(data):
        required_fields = ["clientId", "courtId", "date", "startTime", "endTime"]

        for field in required_fields:
            if field not in data or not data[field]:
                raise ValueError(f"Campo obrigatório ausente: {field}")

        client = UserRepository.get_by_id(data["clientId"])

        if not client:
            raise LookupError("Cliente não encontrado.")

        if client.role != "CLIENT":
            raise ValueError("A reserva deve ser vinculada a um usuário do tipo CLIENT.")

        court = CourtRepository.get_by_id(data["courtId"])

        if not court:
            raise LookupError("Quadra não encontrada.")

        if not court.available:
            raise ValueError("Quadra indisponível para reserva.")

        try:
            reservation_date = date.fromisoformat(data["date"])
            start_time = time.fromisoformat(data["startTime"])
            end_time = time.fromisoformat(data["endTime"])
        except ValueError:
            raise ValueError("Data ou horário inválido. Use date=YYYY-MM-DD e horários HH:MM.")

        if start_time >= end_time:
            raise ValueError("O horário inicial deve ser menor que o horário final.")

        conflict = ReservationRepository.find_conflict(
            court_id=data["courtId"],
            date=reservation_date,
            start_time=start_time,
            end_time=end_time
        )

        if conflict:
            raise ValueError("Já existe uma reserva para esta quadra nesse intervalo.")

        parsed_data = {
            "clientId": data["clientId"],
            "courtId": data["courtId"],
            "date": reservation_date,
            "startTime": start_time,
            "endTime": end_time
        }

        reservation = ReservationRepository.create(parsed_data)

        EventPublisher.publish(
            event_name="reservation.created",
            payload=reservation.to_dict()
        )

        return reservation

    @staticmethod
    def list_reservations():
        return ReservationRepository.get_all()

    @staticmethod
    def get_reservation(reservation_id):
        reservation = ReservationRepository.get_by_id(reservation_id)

        if not reservation:
            raise LookupError("Reserva não encontrada.")

        return reservation

    @staticmethod
    def accept_reservation(reservation_id):
        reservation = ReservationService.get_reservation(reservation_id)

        if reservation.status != "PENDING":
            raise ValueError("Somente reservas pendentes podem ser aceitas.")

        previous_status = reservation.status

        updated_reservation = ReservationRepository.update_status(
            reservation,
            "ACCEPTED"
        )

        EventPublisher.publish(
            event_name="reservation.status_changed",
            payload={
                "reservation": updated_reservation.to_dict(),
                "previousStatus": previous_status,
                "newStatus": "ACCEPTED"
            }
        )

        return updated_reservation

    @staticmethod
    def reject_reservation(reservation_id):
        reservation = ReservationService.get_reservation(reservation_id)

        if reservation.status != "PENDING":
            raise ValueError("Somente reservas pendentes podem ser recusadas.")

        previous_status = reservation.status

        updated_reservation = ReservationRepository.update_status(
            reservation,
            "REJECTED"
        )

        EventPublisher.publish(
            event_name="reservation.status_changed",
            payload={
                "reservation": updated_reservation.to_dict(),
                "previousStatus": previous_status,
                "newStatus": "REJECTED"
            }
        )

        return updated_reservation

    @staticmethod
    def list_by_client(client_id):
        client = UserRepository.get_by_id(client_id)

        if not client:
            raise LookupError("Cliente não encontrado.")

        if client.role != "CLIENT":
            raise ValueError("O usuário informado não possui perfil CLIENT.")

        return ReservationRepository.get_by_client_id(client_id)



    @staticmethod
    def list_by_provider(provider_id):
        provider = UserRepository.get_by_id(provider_id)

        if not provider:
            raise LookupError("Prestador não encontrado.")

        if provider.role != "PROVIDER":
            raise ValueError("O usuário informado não possui perfil PROVIDER.")

        return ReservationRepository.get_by_provider_id(provider_id)

    @staticmethod
    def list_by_status(status):
        valid_statuses = ["PENDING", "ACCEPTED", "REJECTED", "CANCELLED", "FINISHED"]

        normalized_status = status.upper()

        if normalized_status not in valid_statuses:
            raise ValueError("Status inválido.")

        return ReservationRepository.get_by_status(normalized_status)

    @staticmethod
    def cancel_reservation(reservation_id):
        reservation = ReservationService.get_reservation(reservation_id)

        if reservation.status != "PENDING":
            raise ValueError("Somente reservas pendentes podem ser canceladas.")

        previous_status = reservation.status

        updated_reservation = ReservationRepository.update_status(
            reservation,
            "CANCELLED"
        )

        EventPublisher.publish(
            event_name="reservation.cancelled",
            payload={
                "reservation": updated_reservation.to_dict(),
                "previousStatus": previous_status,
                "newStatus": "CANCELLED"
            }
        )

        return updated_reservation

    @staticmethod
    def finish_reservation(reservation_id):
        reservation = ReservationService.get_reservation(reservation_id)

        if reservation.status != "ACCEPTED":
            raise ValueError("Somente reservas aceitas podem ser finalizadas.")

        previous_status = reservation.status

        updated_reservation = ReservationRepository.update_status(
            reservation,
            "FINISHED"
        )

        EventPublisher.publish(
            event_name="reservation.finished",
            payload={
                "reservation": updated_reservation.to_dict(),
                "previousStatus": previous_status,
                "newStatus": "FINISHED"
            }
        )

        return updated_reservation

