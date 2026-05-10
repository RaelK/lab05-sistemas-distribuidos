from datetime import date, time

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

        return ReservationRepository.create(parsed_data)

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

        return ReservationRepository.update_status(reservation, "ACCEPTED")

    @staticmethod
    def reject_reservation(reservation_id):
        reservation = ReservationService.get_reservation(reservation_id)

        if reservation.status != "PENDING":
            raise ValueError("Somente reservas pendentes podem ser recusadas.")

        return ReservationRepository.update_status(reservation, "REJECTED")
