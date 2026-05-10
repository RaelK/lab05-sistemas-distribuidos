from flask import jsonify, request

from app.services.user_service import UserService


def create_user():
    try:
        data = request.get_json()
        user = UserService.create_user(data)

        return jsonify(user.to_dict()), 201

    except ValueError as error:
        return jsonify({"error": str(error)}), 400

    except Exception as error:
        return jsonify({"error": "Erro interno ao criar usuário.", "details": str(error)}), 500


def list_users():
    users = UserService.list_users()

    return jsonify([user.to_dict() for user in users]), 200


def get_user(user_id):
    try:
        user = UserService.get_user(user_id)

        return jsonify(user.to_dict()), 200

    except LookupError as error:
        return jsonify({"error": str(error)}), 404
