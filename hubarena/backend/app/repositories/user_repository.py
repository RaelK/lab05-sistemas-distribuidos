from app.database.db import db
from app.models.user import User


class UserRepository:

    @staticmethod
    def create(data):
        user = User(
            name=data["name"],
            email=data["email"],
            password=data["password"],
            role=data["role"],
            profile_type=data.get("profileType"),
            profile_photo_url=data.get("profilePhotoUrl")
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

    @staticmethod
    def update(user, data):
        if "name" in data:
            user.name = data["name"]

        if "email" in data:
            user.email = data["email"]

        if "profileType" in data:
            user.profile_type = data["profileType"]

        if "profilePhotoUrl" in data:
            user.profile_photo_url = data["profilePhotoUrl"]

        db.session.commit()

        return user

    @staticmethod
    def update_password(user, new_password):
        user.password = new_password
        db.session.commit()

        return user

    @staticmethod
    def clear_profile_photo(user):
        user.profile_photo_url = None
        db.session.commit()

        return user
