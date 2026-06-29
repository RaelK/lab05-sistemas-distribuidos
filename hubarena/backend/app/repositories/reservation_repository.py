from app.database.db import db
from app.models.reservation import Reservation
from app.models.court import Court
from app.models.arena import Arena


class ReservationRepository:

    @staticmethod
    def create(data):
        reservation = Reservation(
            client_id=data["clientId"],
            court_id=data["courtId"],
            date=data["date"],
            start_time=data["startTime"],
            end_time=data["endTime"],
            status="PENDING"
        )

        db.session.add(reservation)
        db.session.commit()

        return reservation

    @staticmethod
    def get_all():
        return Reservation.query.order_by(Reservation.id.asc()).all()

    @staticmethod
    def get_by_id(reservation_id):
        return Reservation.query.get(reservation_id)

    @staticmethod
    def get_by_client_id(client_id):
        return Reservation.query.filter_by(client_id=client_id).order_by(Reservation.id.desc()).all()

    @staticmethod
    def get_by_status(status):
        return Reservation.query.filter_by(status=status).order_by(Reservation.id.desc()).all()

    @staticmethod
    def get_by_provider_id(provider_id):
        return (
            Reservation.query
            .join(Court, Reservation.court_id == Court.id)
            .join(Arena, Court.arena_id == Arena.id)
            .filter(Arena.provider_id == provider_id)
            .order_by(Reservation.id.desc())
            .all()
        )

    @staticmethod
    def update_status(reservation, status):
        reservation.status = status

        db.session.commit()

        return reservation

    @staticmethod
    def find_conflict(court_id, date, start_time, end_time):
        return Reservation.query.filter(
            Reservation.court_id == court_id,
            Reservation.date == date,
            Reservation.status.in_(["PENDING", "ACCEPTED"]),
            Reservation.start_time < end_time,
            Reservation.end_time > start_time
        ).first()
