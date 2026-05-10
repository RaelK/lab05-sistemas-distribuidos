from flask import Blueprint, jsonify
from sqlalchemy import text

from app.database.db import db

health_bp = Blueprint("health", __name__)


@health_bp.get("/health")
def health_check():
    return jsonify({
        "status": "ok",
        "message": "HubArena API is running"
    }), 200


@health_bp.get("/health/db")
def database_health_check():
    try:
        db.session.execute(text("SELECT 1"))
        return jsonify({
            "status": "ok",
            "database": "PostgreSQL connected"
        }), 200
    except Exception as error:
        return jsonify({
            "status": "error",
            "database": "PostgreSQL unavailable",
            "message": str(error)
        }), 500
