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

    @staticmethod
    def login(data):
        email = data.get("email")
        password = data.get("password")

        if not email or not password:
            raise ValueError("E-mail e senha são obrigatórios.")

        user = UserRepository.get_by_email(email)

        if not user or user.password != password:
            raise PermissionError("E-mail ou senha inválidos.")

        return user

    @staticmethod
    def update_user(user_id, data):
        user = UserService.get_user(user_id)

        if "email" in data:
            existing_user = UserRepository.get_by_email(data["email"])
            if existing_user and existing_user.id != user.id:
                raise ValueError("Já existe outro usuário com este e-mail.")

        return UserRepository.update(user, data)

    @staticmethod
    def update_password(user_id, data):
        user = UserService.get_user(user_id)

        current_password = data.get("currentPassword")
        new_password = data.get("newPassword")

        if not current_password or not new_password:
            raise ValueError("Senha atual e nova senha são obrigatórias.")

        if user.password != current_password:
            raise PermissionError("Senha atual incorreta.")

        return UserRepository.update_password(user, new_password)

    @staticmethod
    def update_profile_photo(user_id, data):
        user = UserService.get_user(user_id)

        photo_url = data.get("profilePhotoUrl")

        if not photo_url:
            raise ValueError("profilePhotoUrl é obrigatório.")

        return UserRepository.update(user, {"profilePhotoUrl": photo_url})

    @staticmethod
    def delete_profile_photo(user_id):
        user = UserService.get_user(user_id)

        return UserRepository.clear_profile_photo(user)
