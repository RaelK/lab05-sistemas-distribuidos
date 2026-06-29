from app.database.db import db
from app.models.arena import Arena


class ArenaRepository:

    @staticmethod
    def create(data):
        arena = Arena(
            provider_id=data["providerId"],
            name=data["name"],
            sport=data.get("sport"),
            description=data.get("description"),
            address=data["address"],
            image_url=data.get("imageUrl")
        )

        db.session.add(arena)
        db.session.commit()

        return arena

    @staticmethod
    def get_all():
        return Arena.query.order_by(Arena.id.asc()).all()

    @staticmethod
    def get_by_id(arena_id):
        return Arena.query.get(arena_id)

    @staticmethod
    def update(arena, data):
        if "name" in data:
            arena.name = data["name"]

        if "sport" in data:
            arena.sport = data["sport"]

        if "description" in data:
            arena.description = data["description"]

        if "address" in data:
            arena.address = data["address"]

        if "imageUrl" in data:
            arena.image_url = data["imageUrl"]

        db.session.commit()

        return arena

    @staticmethod
    def delete(arena):
        db.session.delete(arena)
        db.session.commit()

