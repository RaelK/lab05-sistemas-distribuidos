from flask import jsonify, request

from app.services.reservation_service import ReservationService


def create_reservation():
    try:
        data = request.get_json()
        reservation = ReservationService.create_reservation(data)

        return jsonify(reservation.to_dict()), 201

    except ValueError as error:
        return jsonify({"error": str(error)}), 400

    except LookupError as error:
        return jsonify({"error": str(error)}), 404

    except Exception as error:
        return jsonify({"error": "Erro interno ao criar reserva.", "details": str(error)}), 500


def list_reservations():
    reservations = ReservationService.list_reservations()

    return jsonify([reservation.to_dict() for reservation in reservations]), 200


def get_reservation(reservation_id):
    try:
        reservation = ReservationService.get_reservation(reservation_id)

        return jsonify(reservation.to_dict()), 200

    except LookupError as error:
        return jsonify({"error": str(error)}), 404


def accept_reservation(reservation_id):
    try:
        reservation = ReservationService.accept_reservation(reservation_id)

        return jsonify(reservation.to_dict()), 200

    except ValueError as error:
        return jsonify({"error": str(error)}), 400

    except LookupError as error:
        return jsonify({"error": str(error)}), 404


def reject_reservation(reservation_id):
    try:
        reservation = ReservationService.reject_reservation(reservation_id)

        return jsonify(reservation.to_dict()), 200

    except ValueError as error:
        return jsonify({"error": str(error)}), 400

    except LookupError as error:
        return jsonify({"error": str(error)}), 404
