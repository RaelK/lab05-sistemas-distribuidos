from app.repositories.user_repository import UserRepository


class UserService:

    VALID_ROLES = ["CLIENT", "PROVIDER"]

    @staticmethod
    def create_user(data):
        required_fields = ["name", "email", "password", "role"]

        for field in required_fields:
            if field not in data or not data[field]:
                raise ValueError(f"Campo obrigatório ausente: {field}")

        role = data["role"].upper()

        if role not in UserService.VALID_ROLES:
            raise ValueError("Role inválida. Use CLIENT ou PROVIDER.")

        existing_user = UserRepository.get_by_email(data["email"])

        if existing_user:
            raise ValueError("Já existe um usuário com este e-mail.")

        data["role"] = role

        return UserRepository.create(data)

    @staticmethod
    def list_users():
        return UserRepository.get_all()

    @staticmethod
    def get_user(user_id):
        user = UserRepository.get_by_id(user_id)

        if not user:
            raise LookupError("Usuário não encontrado.")

        return user
