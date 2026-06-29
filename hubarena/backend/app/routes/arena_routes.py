from flask import Blueprint

from app.controllers.arena_controller import (
    create_arena,
    list_arenas,
    get_arena,
    update_arena,
    delete_arena,
)

arena_bp = Blueprint("arenas", __name__, url_prefix="/arenas")

arena_bp.post("")(create_arena)
arena_bp.get("")(list_arenas)
arena_bp.get("/<int:arena_id>")(get_arena)
arena_bp.put("/<int:arena_id>")(update_arena)
arena_bp.delete("/<int:arena_id>")(delete_arena)
