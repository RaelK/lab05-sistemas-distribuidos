from flask import jsonify, request

from app.services.court_service import CourtService


def create_court():
    try:
        data = request.get_json()
        court = CourtService.create_court(data)

        return jsonify(court.to_dict()), 201

    except ValueError as error:
        return jsonify({"error": str(error)}), 400

    except LookupError as error:
        return jsonify({"error": str(error)}), 404

    except Exception as error:
        return jsonify({"error": "Erro interno ao criar quadra.", "details": str(error)}), 500


def list_courts():
    courts = CourtService.list_courts()

    return jsonify([court.to_dict() for court in courts]), 200


def get_court(court_id):
    try:
        court = CourtService.get_court(court_id)

        return jsonify(court.to_dict()), 200

    except LookupError as error:
        return jsonify({"error": str(error)}), 404


def update_court(court_id):
    try:
        data = request.get_json()
        court = CourtService.update_court(court_id, data)

        return jsonify(court.to_dict()), 200

    except ValueError as error:
        return jsonify({"error": str(error)}), 400

    except LookupError as error:
        return jsonify({"error": str(error)}), 404

def delete_court(court_id):
    try:
        CourtService.delete_court(court_id)

        return jsonify({"message": "Quadra excluída com sucesso."}), 200

    except LookupError as error:
        return jsonify({"error": str(error)}), 404

