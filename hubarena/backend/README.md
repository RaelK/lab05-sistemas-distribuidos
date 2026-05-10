# HubArena - Backend REST - Sprint 1

## 1. Descrição do Projeto

O HubArena é uma plataforma distribuída para reserva de quadras esportivas. O sistema conecta clientes interessados em reservar quadras com prestadores responsáveis por arenas esportivas.

Na Sprint 1, foi implementado o backend REST com persistência em PostgreSQL, cobrindo o fluxo básico de cadastro de usuários, criação de arenas, criação de quadras, solicitação de reserva e atualização de status.
\n## 2. Perfis de Usuário

### Cliente

Usuário que busca arenas, consulta quadras disponíveis e solicita reservas.

### Prestador

Administrador da arena esportiva, responsável por cadastrar arenas, gerenciar quadras e aceitar ou recusar reservas.
\n## 3. Tecnologias Utilizadas

- Python 3.12
- Flask
- Flask-SQLAlchemy
- Flask-CORS
- PostgreSQL
- Docker Compose
- pg8000
- requests
- PlantUML
- Postman
\n## 4. Arquitetura do Backend

O backend foi organizado em camadas, seguindo boas práticas de separação de responsabilidades.

| Camada | Responsabilidade |
|---|---|
| routes | Define as rotas REST |
| controllers | Recebe requisições HTTP e retorna respostas JSON |
| services | Concentra regras de negócio |
| repositories | Acessa o banco de dados |
| models | Define as entidades persistidas |
| database | Configura o SQLAlchemy |
| config | Centraliza configurações da aplicação |
\n## 5. Componentes Arquiteturais

| Componente | Tecnologia | Função |
|---|---|---|
| App Cliente | Flutter/Dart | Permitir que o cliente crie e acompanhe reservas |
| App Prestador | Flutter/Dart | Permitir que o prestador gerencie solicitações |
| Backend REST | Flask/Python | Expor endpoints e regras de negócio |
| Banco de Dados | PostgreSQL | Persistir dados do domínio |
| MOM | RabbitMQ | Comunicação assíncrona prevista para a Sprint 2 |
\n## 6. Diagrama de Arquitetura

O diagrama PlantUML está localizado em:

docs/architecture.puml

A imagem gerada do diagrama está localizada em:

docs/diagrams/hubarena_architecture.png
\n## 7. Banco de Dados

Banco utilizado: PostgreSQL.

Configuração local via Docker Compose:

| Item | Valor |
|---|---|
| Database | hubarena_db |
| User | hubarena_user |
| Password | hubarena_pass |
| Porta | 5432 |

A documentação do schema está em:

docs/schema.md
\n## 8. Como Executar

### 8.1 Subir o PostgreSQL

docker compose up -d

### 8.2 Ativar o ambiente virtual no Git Bash

source venv/bin/activate

### 8.3 Instalar dependências

pip install -r requirements.txt

### 8.4 Criar as tabelas

python init_db.py

### 8.5 Rodar o backend

python run.py

A API ficará disponível em:

http://127.0.0.1:5000
\n## 9. Endpoints Implementados

### Health

| Método | Endpoint | Descrição |
|---|---|---|
| GET | /health | Verifica se a API está ativa |
| GET | /health/db | Verifica conexão com PostgreSQL |

### Users

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /users | Cria cliente ou prestador |
| GET | /users | Lista usuários |
| GET | /users/{id} | Consulta usuário por ID |

### Arenas

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /arenas | Cria uma arena |
| GET | /arenas | Lista arenas |
| GET | /arenas/{id} | Consulta arena por ID |

### Courts

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /courts | Cria uma quadra |
| GET | /courts | Lista quadras |
| GET | /courts/{id} | Consulta quadra por ID |

### Reservations

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /reservations | Cria uma solicitação de reserva |
| GET | /reservations | Lista reservas |
| GET | /reservations/{id} | Consulta reserva por ID |
| PUT | /reservations/{id}/accept | Aceita reserva pendente |
| PUT | /reservations/{id}/reject | Recusa reserva pendente |
\n## 10. Fluxo Principal Validado

1. Criar usuário prestador.
2. Criar usuário cliente.
3. Criar arena vinculada ao prestador.
4. Criar quadra vinculada à arena.
5. Criar reserva vinculada ao cliente e à quadra.
6. Atualizar status da reserva para ACCEPTED ou REJECTED.
\n## 11. Coleção Postman

A coleção de testes da Sprint 1 está localizada em:

postman/HubArena_Sprint1.postman_collection.json
\n## 12. Eventos Previstos para Sprint 2

| Evento | Descrição |
|---|---|
| reservation_created | Publicado quando uma reserva for criada |
| reservation_accepted | Publicado quando uma reserva for aceita |
| reservation_rejected | Publicado quando uma reserva for recusada |
\n## 13. Estrutura de Pastas

hubarena-backend/
- app/
  - config/
  - controllers/
  - database/
  - models/
  - repositories/
  - routes/
  - services/
- docs/
- postman/
- scripts/
- docker-compose.yml
- init_db.py
- run.py
- requirements.txt
- README.md
\n## 14. Observação

A Sprint 1 implementa o backend REST e prepara a base arquitetural para integração assíncrona com RabbitMQ na Sprint 2.
