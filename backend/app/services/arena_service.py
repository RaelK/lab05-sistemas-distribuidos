from app.repositories.arena_repository import ArenaRepository
from app.repositories.user_repository import UserRepository


class ArenaService:

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
