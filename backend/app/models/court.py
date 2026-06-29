from datetime import datetime
from app.database.db import db


class Court(db.Model):
    __tablename__ = "courts"

    id = db.Column(db.Integer, primary_key=True)

    arena_id = db.Column(
        db.Integer,
        db.ForeignKey("arenas.id"),
        nullable=False
    )

    name = db.Column(db.String(120), nullable=True)
    sport = db.Column(db.String(80), nullable=False)
    description = db.Column(db.String(500), nullable=True)
    image_url = db.Column(db.String(700), nullable=True)

    price_hour = db.Column(db.Float, nullable=False)
    capacity = db.Column(db.Integer, nullable=False)
    available = db.Column(db.Boolean, default=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    arena = db.relationship("Arena", back_populates="courts")

    reservations = db.relationship(
        "Reservation",
        back_populates="court",
        cascade="all, delete-orphan"
    )

    def to_dict(self):
        return {
            "id": self.id,
            "arenaId": self.arena_id,
            "name": self.name or f"Quadra de {self.sport}",
            "sport": self.sport,
            "description": self.description,
            "imageUrl": self.image_url,
            "priceHour": self.price_hour,
            "capacity": self.capacity,
            "available": self.available,
            "createdAt": self.created_at.isoformat() if self.created_at else None
        }
