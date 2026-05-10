from flask import jsonify, request

from app.services.arena_service import ArenaService


def create_arena():
    try:
        data = request.get_json()
        arena = ArenaService.create_arena(data)

        return jsonify(arena.to_dict()), 201

    except ValueError as error:
        return jsonify({"error": str(error)}), 400

    except LookupError as error:
        return jsonify({"error": str(error)}), 404

    except Exception as error:
        return jsonify({"error": "Erro interno ao criar arena.", "details": str(error)}), 500


def list_arenas():
    arenas = ArenaService.list_arenas()

    return jsonify([arena.to_dict() for arena in arenas]), 200


def get_arena(arena_id):
    try:
        arena = ArenaService.get_arena(arena_id)

        return jsonify(arena.to_dict()), 200

    except LookupError as error:
        return jsonify({"error": str(error)}), 404
