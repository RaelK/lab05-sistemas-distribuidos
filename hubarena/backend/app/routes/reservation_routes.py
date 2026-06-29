from flask import Blueprint

from app.controllers.reservation_controller import (
    create_reservation,
    list_reservations,
    get_reservation,
    accept_reservation,
    reject_reservation,
    list_reservations_by_client,
    list_reservations_by_provider,
    list_reservations_by_status,
    cancel_reservation,
    finish_reservation,
)

reservation_bp = Blueprint("reservations", __name__, url_prefix="/reservations")

reservation_bp.post("")(create_reservation)
reservation_bp.get("")(list_reservations)
reservation_bp.get("/client/<int:client_id>")(list_reservations_by_client)
reservation_bp.get("/provider/<int:provider_id>")(list_reservations_by_provider)
reservation_bp.get("/status/<string:status>")(list_reservations_by_status)
reservation_bp.get("/<int:reservation_id>")(get_reservation)
reservation_bp.put("/<int:reservation_id>/accept")(accept_reservation)
reservation_bp.put("/<int:reservation_id>/reject")(reject_reservation)
reservation_bp.put("/<int:reservation_id>/cancel")(cancel_reservation)
reservation_bp.put("/<int:reservation_id>/finish")(finish_reservation)
