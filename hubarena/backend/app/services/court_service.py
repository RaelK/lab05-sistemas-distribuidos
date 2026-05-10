from app.repositories.arena_repository import ArenaRepository
from app.repositories.court_repository import CourtRepository


class CourtService:

    @staticmethod
    def create_court(data):
        required_fields = ["arenaId", "sport", "priceHour", "capacity"]

        for field in required_fields:
            if field not in data or data[field] is None:
                raise ValueError(f"Campo obrigatório ausente: {field}")

        arena = ArenaRepository.get_by_id(data["arenaId"])

        if not arena:
            raise LookupError("Arena não encontrada.")

        if data["priceHour"] <= 0:
            raise ValueError("O valor por hora deve ser maior que zero.")

        if data["capacity"] <= 0:
            raise ValueError("A capacidade deve ser maior que zero.")

        return CourtRepository.create(data)

    @staticmethod
    def list_courts():
        return CourtRepository.get_all()

    @staticmethod
    def get_court(court_id):
        court = CourtRepository.get_by_id(court_id)

        if not court:
            raise LookupError("Quadra não encontrada.")

        return court
