from app.database.db import db
from app.models.court import Court


class CourtRepository:

    @staticmethod
    def create(data):
        court = Court(
            arena_id=data["arenaId"],
            sport=data["sport"],
            price_hour=data["priceHour"],
            capacity=data["capacity"],
            available=data.get("available", True)
        )

        db.session.add(court)
        db.session.commit()

        return court

    @staticmethod
    def get_all():
        return Court.query.order_by(Court.id.asc()).all()

    @staticmethod
    def get_by_id(court_id):
        return Court.query.get(court_id)
