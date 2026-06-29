from app.repositories.arena_repository import ArenaRepository
from app.repositories.user_repository import UserRepository


class ArenaService:

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
        "natacao": "https://images.pexels.com/photos/261185/pexels-photo-261185.jpeg",
        "natação": "https://images.pexels.com/photos/261185/pexels-photo-261185.jpeg",
        "swimming": "https://images.pexels.com/photos/261185/pexels-photo-261185.jpeg",
    }

    @staticmethod
    def _default_image_for_sport(sport):
        if not sport:
            return "https://images.pexels.com/photos/274422/pexels-photo-274422.jpeg"

        normalized = sport.lower().strip()

        for key, image in ArenaService.DEFAULT_IMAGES.items():
            if key in normalized:
                return image

        return "https://images.pexels.com/photos/274422/pexels-photo-274422.jpeg"

    @staticmethod
    def _prepare_image(data):
        if not data.get("imageUrl"):
            data["imageUrl"] = ArenaService._default_image_for_sport(
                data.get("sport")
            )

        return data

    @staticmethod
    def create_arena(data):
        required_fields = ["providerId", "name", "address"]

        for field in required_fields:
            if field not in data or not data[field]:
                raise ValueError(f"Campo obrigatório ausente: {field}")

        provider = UserRepository.get_by_id(data["providerId"])

        if not provider:
            raise LookupError("Prestador não encontrado.")

        if provider.role != "PROVIDER":
            raise ValueError("A arena deve ser vinculada a um usuário do tipo PROVIDER.")

        data = ArenaService._prepare_image(data)

        return ArenaRepository.create(data)

    @staticmethod
    def list_arenas():
        return ArenaRepository.get_all()

    @staticmethod
    def get_arena(arena_id):
        arena = ArenaRepository.get_by_id(arena_id)

        if not arena:
            raise LookupError("Arena não encontrada.")

        return arena

    @staticmethod
    def update_arena(arena_id, data):
        arena = ArenaService.get_arena(arena_id)

        if "sport" in data and data["sport"]:
            if not data.get("imageUrl"):
                data["imageUrl"] = ArenaService._default_image_for_sport(
                    data["sport"]
                )

        return ArenaRepository.update(arena, data)

    @staticmethod
    def delete_arena(arena_id):
        arena = ArenaService.get_arena(arena_id)

        return ArenaRepository.delete(arena)

