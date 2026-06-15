from flask import Blueprint

from app.controllers.court_controller import create_court, list_courts, get_court

court_bp = Blueprint("courts", __name__, url_prefix="/courts")

court_bp.post("")(create_court)
court_bp.get("")(list_courts)
court_bp.get("/<int:court_id>")(get_court)
