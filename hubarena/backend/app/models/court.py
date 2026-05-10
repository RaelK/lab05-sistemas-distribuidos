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

    sport = db.Column(db.String(80), nullable=False)
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
            "sport": self.sport,
            "priceHour": self.price_hour,
            "capacity": self.capacity,
            "available": self.available,
            "createdAt": self.created_at.isoformat() if self.created_at else None
        }
