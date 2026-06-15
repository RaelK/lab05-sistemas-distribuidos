from app.database.db import db
from app.models.user import User


class UserRepository:

    @staticmethod
    def create(data):
        user = User(
            name=data["name"],
            email=data["email"],
            password=data["password"],
            role=data["role"]
        )

        db.session.add(user)
        db.session.commit()

        return user

    @staticmethod
    def get_all():
        return User.query.order_by(User.id.asc()).all()

    @staticmethod
    def get_by_id(user_id):
        return User.query.get(user_id)

    @staticmethod
    def get_by_email(email):
        return User.query.filter_by(email=email).first()
