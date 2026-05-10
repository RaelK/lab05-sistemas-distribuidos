from flask import Blueprint

from app.controllers.user_controller import create_user, list_users, get_user

user_bp = Blueprint("users", __name__, url_prefix="/users")

user_bp.post("")(create_user)
user_bp.get("")(list_users)
user_bp.get("/<int:user_id>")(get_user)
