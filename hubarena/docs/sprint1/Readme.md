# HubArena – Sprint 1

## Backend REST com PostgreSQL

Este documento descreve a entrega da Sprint 1 do projeto **HubArena**, correspondente à implementação inicial do backend REST da plataforma.

A Sprint 1 teve como objetivo construir a base da aplicação distribuída, com API REST, persistência em banco PostgreSQL e endpoints para cadastro e consulta dos principais recursos do domínio.

---

## 1. Objetivo da Sprint 1

Implementar o backend REST inicial do HubArena, permitindo o cadastro de usuários, arenas, quadras e reservas.

Nesta etapa, o sistema deveria permitir o fluxo básico:

```text
Prestador cadastra arena
        ↓
Prestador cadastra quadra
        ↓
Cliente solicita reserva
        ↓
Prestador aceita ou recusa
```

---

## 2. Componentes Implementados

| Componente | Descrição |
|---|---|
| Backend Flask | API REST da aplicação |
| PostgreSQL | Banco de dados relacional |
| SQLAlchemy | Mapeamento objeto-relacional |
| Docker Compose | Execução local do banco |
| Postman | Testes dos endpoints |
| Documentação | Arquitetura, schema e evidências |

---

## 3. Tecnologias Utilizadas

| Tecnologia | Função |
|---|---|
| Python | Linguagem do backend |
| Flask | Framework da API REST |
| Flask-SQLAlchemy | ORM |
| Flask-CORS | Liberação de acesso entre aplicações |
| PostgreSQL | Banco de dados |
| Docker Compose | Ambiente local |
| Postman | Validação dos endpoints |

---

## 4. Estrutura do Backend

A aplicação foi organizada em camadas:

```text
backend/
├── app/
│   ├── config/
│   ├── controllers/
│   ├── database/
│   ├── models/
│   ├── repositories/
│   ├── routes/
│   └── services/
├── docs/
├── postman/
├── scripts/
├── docker-compose.yml
├── init_db.py
├── requirements.txt
└── run.py
```

---

## 5. Entidades Principais

### User

Representa os usuários da plataforma.

Perfis disponíveis:

| Role | Descrição |
|---|---|
| CLIENT | Cliente que solicita reservas |
| PROVIDER | Prestador que cadastra arenas e quadras |

### Arena

Representa um espaço esportivo administrado por um prestador.

### Court

Representa uma quadra pertencente a uma arena.

### Reservation

Representa a solicitação de reserva feita por um cliente para uma quadra.

---

## 6. Endpoints da Sprint 1

### Health

| Método | Endpoint | Descrição |
|---|---|---|
| GET | `/health` | Verifica se a API está ativa |
| GET | `/health/db` | Verifica conexão com PostgreSQL |

### Users

| Método | Endpoint | Descrição |
|---|---|---|
| POST | `/users` | Cria usuário |
| GET | `/users` | Lista usuários |
| GET | `/users/{id}` | Consulta usuário por ID |

### Arenas

| Método | Endpoint | Descrição |
|---|---|---|
| POST | `/arenas` | Cria arena |
| GET | `/arenas` | Lista arenas |
| GET | `/arenas/{id}` | Consulta arena por ID |

### Courts

| Método | Endpoint | Descrição |
|---|---|---|
| POST | `/courts` | Cria quadra |
| GET | `/courts` | Lista quadras |
| GET | `/courts/{id}` | Consulta quadra por ID |

### Reservations

| Método | Endpoint | Descrição |
|---|---|---|
| POST | `/reservations` | Cria reserva |
| GET | `/reservations` | Lista reservas |
| GET | `/reservations/{id}` | Consulta reserva por ID |
| PUT | `/reservations/{id}/accept` | Aceita reserva |
| PUT | `/reservations/{id}/reject` | Recusa reserva |

---

## 7. Como Executar

Na pasta `backend/`, execute:

```bash
docker compose up -d
```

Depois ative o ambiente virtual:

```bash
source .venv/Scripts/activate
```

Instale as dependências:

```bash
pip install -r requirements.txt
```

Crie as tabelas:

```bash
python init_db.py
```

Execute a API:

```bash
python run.py
```

A API ficará disponível em:

```text
http://127.0.0.1:5000
```

---

## 8. Fluxo de Teste Recomendado

Execute no Postman:

```text
GET /health
GET /health/db
POST /users              criar PROVIDER
POST /users              criar CLIENT
POST /arenas
POST /courts
POST /reservations
PUT /reservations/{id}/accept
```

ou substitua o último passo por:

```text
PUT /reservations/{id}/reject
```

---

## 9. Coleção Postman

A coleção Postman da Sprint 1 está localizada em:

```text
backend/postman/HubArena_Sprint1.postman_collection.json
```

Ela contém os endpoints necessários para validar o fluxo básico da API.

---

## 10. Evidências da Sprint 1

A Sprint 1 gerou evidências de:

```text
backend/docs/api_test_results.md
backend/docs/schema.md
backend/docs/architecture.md
backend/docs/architecture.puml
backend/docs/diagrams/hubarena_architecture.png
```

Também pode haver cópia consolidada em:

```text
docs/sprint1/
```

---

## 11. Resultado da Sprint 1

Ao final da Sprint 1, o HubArena possuía um backend REST funcional com persistência em PostgreSQL, permitindo criar usuários, arenas, quadras e reservas, além de aceitar ou recusar solicitações.

Essa entrega serviu como base para as próximas sprints, especialmente para a integração assíncrona com RabbitMQ na Sprint 2 e para os aplicativos Flutter nas Sprints 3 e 4.
