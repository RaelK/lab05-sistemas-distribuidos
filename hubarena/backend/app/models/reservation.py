from datetime import datetime
from app.database.db import db


class Reservation(db.Model):
    __tablename__ = "reservations"

    id = db.Column(db.Integer, primary_key=True)

    client_id = db.Column(
        db.Integer,
        db.ForeignKey("users.id"),
        nullable=False
    )

    court_id = db.Column(
        db.Integer,
        db.ForeignKey("courts.id"),
        nullable=False
    )

    date = db.Column(db.Date, nullable=False)
    start_time = db.Column(db.Time, nullable=False)
    end_time = db.Column(db.Time, nullable=False)

    status = db.Column(db.String(20), default="PENDING", nullable=False)

    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(
        db.DateTime,
        default=datetime.utcnow,
        onupdate=datetime.utcnow
    )

    client = db.relationship("User", back_populates="reservations")
    court = db.relationship("Court", back_populates="reservations")

    def to_dict(self):
        return {
            "id": self.id,
            "clientId": self.client_id,
            "courtId": self.court_id,
            "date": self.date.isoformat() if self.date else None,
            "startTime": self.start_time.strftime("%H:%M") if self.start_time else None,
            "endTime": self.end_time.strftime("%H:%M") if self.end_time else None,
            "status": self.status,
            "createdAt": self.created_at.isoformat() if self.created_at else None,
            "updatedAt": self.updated_at.isoformat() if self.updated_at else None
        }
