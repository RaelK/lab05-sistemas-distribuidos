from app import create_app
from app.database.db import db

from app.models import User, Arena, Court, Reservation


app = create_app()

with app.app_context():
    db.create_all()
    print("Banco de dados inicializado com sucesso.")
    print("Tabelas criadas: users, arenas, courts, reservations.")
