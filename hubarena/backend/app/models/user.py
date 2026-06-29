from datetime import datetime
from app.database.db import db


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)

    name = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(20), nullable=False)

    profile_photo_url = db.Column(db.String(500), nullable=True)
    profile_type = db.Column(db.String(40), nullable=True)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)

    arenas = db.relationship(
        "Arena",
        back_populates="provider",
        cascade="all, delete-orphan"
    )

    reservations = db.relationship(
        "Reservation",
        back_populates="client",
        cascade="all, delete-orphan"
    )

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "email": self.email,
            "role": self.role,
            "profilePhotoUrl": self.profile_photo_url,
            "profileType": self.profile_type,
            "createdAt": self.created_at.isoformat() if self.created_at else None
        }
