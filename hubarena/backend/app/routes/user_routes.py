from flask import Blueprint

from app.controllers.user_controller import (
    create_user,
    list_users,
    get_user,
    login,
    update_user,
    update_password,
    update_profile_photo,
    delete_profile_photo,
)

user_bp = Blueprint("users", __name__, url_prefix="/users")

user_bp.post("")(create_user)
user_bp.get("")(list_users)
user_bp.get("/<int:user_id>")(get_user)
user_bp.put("/<int:user_id>")(update_user)
user_bp.put("/<int:user_id>/password")(update_password)
user_bp.put("/<int:user_id>/profile-photo")(update_profile_photo)
user_bp.delete("/<int:user_id>/profile-photo")(delete_profile_photo)

user_bp.post("/login")(login)
