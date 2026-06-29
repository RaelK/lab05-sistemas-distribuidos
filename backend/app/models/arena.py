from datetime import datetime
from app.database.db import db


class Arena(db.Model):
    __tablename__ = "arenas"

    id = db.Column(db.Integer, primary_key=True)

    provider_id = db.Column(
        db.Integer,
        db.ForeignKey("users.id"),
        nullable=False
    )

    name = db.Column(db.String(120), nullable=False)
    sport = db.Column(db.String(80), nullable=True)
    description = db.Column(db.Text, nullable=True)
    address = db.Column(db.String(255), nullable=False)
    image_url = db.Column(db.String(700), nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    provider = db.relationship("User", back_populates="arenas")

    courts = db.relationship(
        "Court",
        back_populates="arena",
        cascade="all, delete-orphan"
    )

    def to_dict(self):
        return {
            "id": self.id,
            "providerId": self.provider_id,
            "name": self.name,
            "sport": self.sport,
            "description": self.description,
            "address": self.address,
            "imageUrl": self.image_url,
            "createdAt": self.created_at.isoformat() if self.created_at else None
        }
