from app.repositories.arena_repository import ArenaRepository
from app.repositories.court_repository import CourtRepository


class CourtService:

    DEFAULT_IMAGES = {
        "futebol": "https://images.pexels.com/photos/399187/pexels-photo-399187.jpeg",
        "soccer": "https://images.pexels.com/photos/399187/pexels-photo-399187.jpeg",
        "basquete": "https://images.pexels.com/photos/1752757/pexels-photo-1752757.jpeg",
        "basketball": "https://images.pexels.com/photos/1752757/pexels-photo-1752757.jpeg",
        "tenis": "https://images.pexels.com/photos/209977/pexels-photo-209977.jpeg",
        "tênis": "https://images.pexels.com/photos/209977/pexels-photo-209977.jpeg",
        "tennis": "https://images.pexels.com/photos/209977/pexels-photo-209977.jpeg",
        "volei": "https://images.pexels.com/photos/1263426/pexels-photo-1263426.jpeg",
        "vôlei": "https://images.pexels.com/photos/1263426/pexels-photo-1263426.jpeg",
        "volleyball": "https://images.pexels.com/photos/1263426/pexels-photo-1263426.jpeg",
        "beach tennis": "https://images.pexels.com/photos/1432039/pexels-photo-1432039.jpeg",
    }

    @staticmethod
    def _default_image_for_sport(sport):
        normalized = sport.lower().strip()

        for key, image in CourtService.DEFAULT_IMAGES.items():
            if key in normalized:
                return image

        return "https://images.pexels.com/photos/274422/pexels-photo-274422.jpeg"

    @staticmethod
    def _prepare_image(data):
        if not data.get("imageUrl"):
            data["imageUrl"] = CourtService._default_image_for_sport(data["sport"])

        return data

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

        data = CourtService._prepare_image(data)

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

    @staticmethod
    def update_court(court_id, data):
        court = CourtService.get_court(court_id)

        if "sport" in data and data["sport"]:
            if not data.get("imageUrl"):
                data["imageUrl"] = CourtService._default_image_for_sport(data["sport"])

        if "priceHour" in data and data["priceHour"] <= 0:
            raise ValueError("O valor por hora deve ser maior que zero.")

        if "capacity" in data and data["capacity"] <= 0:
            raise ValueError("A capacidade deve ser maior que zero.")

        return CourtRepository.update(court, data)

    @staticmethod
    def delete_court(court_id):
        court = CourtService.get_court(court_id)

        return CourtRepository.delete(court)

