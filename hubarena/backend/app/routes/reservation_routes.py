from flask import Blueprint

from app.controllers.reservation_controller import (
    create_reservation,
    list_reservations,
    get_reservation,
    accept_reservation,
    reject_reservation
)

reservation_bp = Blueprint("reservations", __name__, url_prefix="/reservations")

reservation_bp.post("")(create_reservation)
reservation_bp.get("")(list_reservations)
reservation_bp.get("/<int:reservation_id>")(get_reservation)
reservation_bp.put("/<int:reservation_id>/accept")(accept_reservation)
reservation_bp.put("/<int:reservation_id>/reject")(reject_reservation)
