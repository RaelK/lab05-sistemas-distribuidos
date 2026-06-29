from app.database.db import db
from app.models.court import Court


class CourtRepository:

    @staticmethod
    def create(data):
        court = Court(
            arena_id=data["arenaId"],
            name=data.get("name"),
            sport=data["sport"],
            description=data.get("description"),
            image_url=data.get("imageUrl"),
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

    @staticmethod
    def update(court, data):
        if "name" in data:
            court.name = data["name"]

        if "sport" in data:
            court.sport = data["sport"]

        if "description" in data:
            court.description = data["description"]

        if "imageUrl" in data:
            court.image_url = data["imageUrl"]

        if "priceHour" in data:
            court.price_hour = data["priceHour"]

        if "capacity" in data:
            court.capacity = data["capacity"]

        if "available" in data:
            court.available = data["available"]

        db.session.commit()

        return court

    @staticmethod
    def delete(court):
        db.session.delete(court)
        db.session.commit()

