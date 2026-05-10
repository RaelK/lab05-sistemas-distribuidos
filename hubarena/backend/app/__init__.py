from flask import Flask
from flask_cors import CORS

from app.config.config import Config
from app.database.db import db

from app.routes.health_routes import health_bp
from app.routes.user_routes import user_bp
from app.routes.arena_routes import arena_bp
from app.routes.court_routes import court_bp
from app.routes.reservation_routes import reservation_bp


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    CORS(app)
    db.init_app(app)

    app.register_blueprint(health_bp)
    app.register_blueprint(user_bp)
    app.register_blueprint(arena_bp)
    app.register_blueprint(court_bp)
    app.register_blueprint(reservation_bp)

    return app
