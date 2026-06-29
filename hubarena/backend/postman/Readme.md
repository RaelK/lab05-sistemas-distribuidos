# HubArena - Documentação da API REST e Coleção Postman

Este documento descreve a coleção Postman e os principais endpoints REST implementados no projeto **HubArena** até a Sprint 4.

A documentação original da Sprint 1 foi ampliada para refletir a versão final do sistema, incluindo autenticação, atualização de perfil, CRUD de arenas, CRUD de quadras, gerenciamento completo de reservas e integração assíncrona com RabbitMQ.

---

## 1. Objetivoa

A coleção Postman tem como objetivo validar o funcionamento da API REST do HubArena e apoiar a demonstração do fluxo completo da aplicação distribuída.

O fluxo principal validado é:

```text
Cliente cria solicitação de reserva
        ↓
Backend REST valida e persiste a reserva
        ↓
Backend publica evento no RabbitMQ
        ↓
Prestador é atualizado por polling/evento
        ↓
Prestador aceita ou recusa a reserva
        ↓
Backend atualiza status e publica novo evento
        ↓
Cliente visualiza a atualização
```

---

## 2. URL Base da API

A API deve estar em execução localmente em:

```text
http://127.0.0.1:5000
```

Para o aplicativo Flutter rodando no Android Emulator, a URL equivalente é:

```text
http://10.0.2.2:5000
```

---

## 3. Como Executar o Backend

Na pasta `backend/`:

```bash
docker compose up -d
source .venv/Scripts/activate
python init_db.py
python run.py
```

Caso os containers já existam:

```bash
docker start hubarena-postgres hubarena-rabbitmq
```

---

## 4. Como Executar o Consumer RabbitMQ

Em outro terminal:

```bash
cd backend
source .venv/Scripts/activate
python -m app.messaging.reservation_consumer
```

O consumer deve permanecer em execução durante a validação da comunicação assíncrona.

---

## 5. Organização da Coleção Postman

A coleção deve estar organizada nos seguintes grupos:

```text
Health
Users
Arenas
Courts
Reservations
RabbitMQ / Eventos
Fluxo Completo Sprint 4
```

---

# 6. Health

## 6.1 GET /health/api

Verifica se a API Flask está ativa.

```http
GET http://127.0.0.1:5000/health/api
```

Resposta esperada:

```json
{
  "message": "HubArena API is running",
  "status": "ok"
}
```

Status esperado:

```text
200 OK
```

---

## 6.2 GET /health/db

Verifica se o backend consegue se conectar ao PostgreSQL.

```http
GET http://127.0.0.1:5000/health/db
```

Resposta esperada:

```json
{
  "database": "PostgreSQL connected",
  "status": "ok"
}
```

Status esperado:

```text
200 OK
```

---

## 6.3 GET /health/rabbitmq

Verifica se o backend consegue se conectar ao RabbitMQ.

```http
GET http://127.0.0.1:5000/health/rabbitmq
```

Resposta esperada:

```json
{
  "rabbitmq": "connected",
  "status": "ok"
}
```

Status esperado:

```text
200 OK
```

---

# 7. Users

## 7.1 POST /users - Create Provider

```http
POST http://127.0.0.1:5000/users
```

Body:

```json
{
  "name": "Arena Pampulha",
  "email": "prestador@hubarena.com",
  "password": "123456",
  "role": "PROVIDER",
  "profileType": "EMPRESA"
}
```

Status esperado: `201 Created`

---

## 7.2 POST /users - Create Client

```http
POST http://127.0.0.1:5000/users
```

Body:

```json
{
  "name": "Jose Cliente",
  "email": "cliente@hubarena.com",
  "password": "123456",
  "role": "CLIENT"
}
```

Status esperado: `201 Created`

---

## 7.3 POST /users/login - Login

```http
POST http://127.0.0.1:5000/users/login
```

Body:

```json
{
  "email": "cliente@hubarena.com",
  "password": "123456"
}
```

Status esperado: `200 OK`

---

## 7.4 GET /users

```http
GET http://127.0.0.1:5000/users
```

Status esperado: `200 OK`

---

## 7.5 GET /users/{id}

```http
GET http://127.0.0.1:5000/users/1
```

Status esperado: `200 OK`

---

## 7.6 PUT /users/{id}

```http
PUT http://127.0.0.1:5000/users/1
```

Body:

```json
{
  "name": "Arena Pampulha Esportes",
  "email": "prestador@hubarena.com",
  "profileType": "EMPRESA"
}
```

Status esperado: `200 OK`

---

## 7.7 PUT /users/{id}/password

```http
PUT http://127.0.0.1:5000/users/1/password
```

Body:

```json
{
  "currentPassword": "123456",
  "newPassword": "1234567"
}
```

Status esperado: `200 OK`

---

## 7.8 PUT /users/{id}/profile-photo

```http
PUT http://127.0.0.1:5000/users/1/profile-photo
```

Body:

```json
{
  "profilePhotoUrl": "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg"
}
```

Status esperado: `200 OK`

---

## 7.9 DELETE /users/{id}/profile-photo

```http
DELETE http://127.0.0.1:5000/users/1/profile-photo
```

Status esperado: `200 OK`

---

# 8. Arenas

## 8.1 POST /arenas

```http
POST http://127.0.0.1:5000/arenas
```

Body:

```json
{
  "providerId": 1,
  "name": "HubArena Pampulha",
  "sport": "Futebol",
  "description": "Arena esportiva com quadras de futebol society e futsal.",
  "address": "Avenida Antonio Carlos, Belo Horizonte - MG",
  "imageUrl": ""
}
```

Se `imageUrl` estiver vazio, o backend atribui automaticamente uma imagem padrão de acordo com o esporte.

Status esperado: `201 Created`

---

## 8.2 GET /arenas

```http
GET http://127.0.0.1:5000/arenas
```

Status esperado: `200 OK`

---

## 8.3 GET /arenas/{id}

```http
GET http://127.0.0.1:5000/arenas/1
```

Status esperado: `200 OK`

---

## 8.4 PUT /arenas/{id}

```http
PUT http://127.0.0.1:5000/arenas/1
```

Body:

```json
{
  "name": "HubArena Pampulha Premium",
  "sport": "Futebol",
  "description": "Arena atualizada com quadras de futebol.",
  "address": "Belo Horizonte - MG",
  "imageUrl": "https://images.pexels.com/photos/274422/pexels-photo-274422.jpeg"
}
```

Status esperado: `200 OK`

---

## 8.5 DELETE /arenas/{id}

```http
DELETE http://127.0.0.1:5000/arenas/1
```

Status esperado: `200 OK`

---

# 9. Courts

## 9.1 POST /courts

```http
POST http://127.0.0.1:5000/courts
```

Body:

```json
{
  "arenaId": 1,
  "name": "Quadra Society 1",
  "sport": "Futebol",
  "description": "Quadra society com grama sintética.",
  "priceHour": 120.0,
  "capacity": 10,
  "available": true,
  "imageUrl": ""
}
```

Se `imageUrl` estiver vazio, o backend atribui automaticamente uma imagem padrão de acordo com o esporte.

Status esperado: `201 Created`

---

## 9.2 GET /courts

```http
GET http://127.0.0.1:5000/courts
```

Status esperado: `200 OK`

---

## 9.3 GET /courts/{id}

```http
GET http://127.0.0.1:5000/courts/1
```

Status esperado: `200 OK`

---

## 9.4 PUT /courts/{id}

```http
PUT http://127.0.0.1:5000/courts/1
```

Body:

```json
{
  "name": "Quadra Society Premium",
  "sport": "Futebol",
  "description": "Quadra atualizada.",
  "priceHour": 150.0,
  "capacity": 12,
  "available": true,
  "imageUrl": "https://images.pexels.com/photos/399187/pexels-photo-399187.jpeg"
}
```

Status esperado: `200 OK`

---

## 9.5 DELETE /courts/{id}

```http
DELETE http://127.0.0.1:5000/courts/1
```

Status esperado: `200 OK`

---

# 10. Reservations

Status utilizados:

| Status | Descrição |
|---|---|
| `PENDING` | Reserva criada e aguardando resposta do prestador |
| `ACCEPTED` | Reserva aceita pelo prestador |
| `REJECTED` | Reserva recusada pelo prestador |
| `CANCELLED` | Reserva cancelada pelo cliente |
| `FINISHED` | Reserva finalizada pelo prestador |

## 10.1 POST /reservations

```http
POST http://127.0.0.1:5000/reservations
```

Body:

```json
{
  "clientId": 2,
  "courtId": 1,
  "date": "2026-07-01",
  "startTime": "19:00",
  "endTime": "20:00"
}
```

Ao criar a reserva, o backend publica o evento `reservation.created` no RabbitMQ.

Status esperado: `201 Created`

---

## 10.2 GET /reservations

```http
GET http://127.0.0.1:5000/reservations
```

Status esperado: `200 OK`

---

## 10.3 GET /reservations/{id}

```http
GET http://127.0.0.1:5000/reservations/1
```

Status esperado: `200 OK`

---

## 10.4 GET /reservations/client/{client_id}

```http
GET http://127.0.0.1:5000/reservations/client/2
```

Status esperado: `200 OK`

---

## 10.5 GET /reservations/provider/{provider_id}

```http
GET http://127.0.0.1:5000/reservations/provider/1
```

Status esperado: `200 OK`

---

## 10.6 GET /reservations/status/{status}

```http
GET http://127.0.0.1:5000/reservations/status/PENDING
```

Status esperado: `200 OK`

---

## 10.7 PUT /reservations/{id}/accept

```http
PUT http://127.0.0.1:5000/reservations/1/accept
```

Ao aceitar, o backend publica o evento `reservation.status_changed`.

Status esperado: `200 OK`

---

## 10.8 PUT /reservations/{id}/reject

```http
PUT http://127.0.0.1:5000/reservations/1/reject
```

Ao recusar, o backend publica o evento `reservation.status_changed`.

Status esperado: `200 OK`

---

## 10.9 PUT /reservations/{id}/cancel

```http
PUT http://127.0.0.1:5000/reservations/1/cancel
```

Ao cancelar, o backend publica o evento `reservation.cancelled`.

Status esperado: `200 OK`

---

## 10.10 PUT /reservations/{id}/finish

```http
PUT http://127.0.0.1:5000/reservations/1/finish
```

Ao finalizar, o backend publica o evento `reservation.finished`.

Status esperado: `200 OK`

---

# 11. Eventos RabbitMQ

A comunicação assíncrona é demonstrada por meio da publicação de eventos no RabbitMQ.

| Evento | Quando ocorre |
|---|---|
| `reservation.created` | Quando o cliente cria uma reserva |
| `reservation.status_changed` | Quando o prestador aceita ou recusa |
| `reservation.cancelled` | Quando o cliente cancela |
| `reservation.finished` | Quando o prestador finaliza |

Com o consumer executando:

```bash
python -m app.messaging.reservation_consumer
```

Ao criar uma reserva, deve aparecer no terminal um evento semelhante a:

```json
{
  "event": "reservation.created",
  "producer": "hubarena-backend",
  "payload": {
    "reservationId": 1,
    "clientId": 2,
    "courtId": 1,
    "status": "PENDING"
  }
}
```

Após o aceite da reserva:

```json
{
  "event": "reservation.status_changed",
  "producer": "hubarena-backend",
  "payload": {
    "reservationId": 1,
    "status": "ACCEPTED"
  }
}
```

---

# 12. Ordem recomendada para teste no Postman

1. `GET /health/api`
2. `GET /health/db`
3. `GET /health/rabbitmq`
4. `POST /users` criando um `PROVIDER`
5. `POST /users` criando um `CLIENT`
6. `POST /users/login`
7. `POST /arenas`
8. `GET /arenas`
9. `POST /courts`
10. `GET /courts`
11. `POST /reservations`
12. Verificar evento `reservation.created` no consumer
13. `GET /reservations/provider/{provider_id}`
14. `PUT /reservations/{id}/accept`
15. Verificar evento `reservation.status_changed` no consumer
16. `GET /reservations/client/{client_id}`
17. `PUT /reservations/{id}/finish`
18. Verificar evento `reservation.finished` no consumer

---

# 13. Relação consolidada dos endpoints

| Grupo | Método | Endpoint | Descrição |
|---|---|---|---|
| Health | GET | `/health/api` | Verifica se a API está ativa |
| Health | GET | `/health/db` | Verifica PostgreSQL |
| Health | GET | `/health/rabbitmq` | Verifica RabbitMQ |
| Users | POST | `/users` | Cria usuário |
| Users | POST | `/users/login` | Login |
| Users | GET | `/users` | Lista usuários |
| Users | GET | `/users/{id}` | Consulta usuário |
| Users | PUT | `/users/{id}` | Atualiza perfil |
| Users | PUT | `/users/{id}/password` | Atualiza senha |
| Users | PUT | `/users/{id}/profile-photo` | Atualiza foto |
| Users | DELETE | `/users/{id}/profile-photo` | Remove foto |
| Arenas | POST | `/arenas` | Cria arena |
| Arenas | GET | `/arenas` | Lista arenas |
| Arenas | GET | `/arenas/{id}` | Consulta arena |
| Arenas | PUT | `/arenas/{id}` | Atualiza arena |
| Arenas | DELETE | `/arenas/{id}` | Exclui arena |
| Courts | POST | `/courts` | Cria quadra |
| Courts | GET | `/courts` | Lista quadras |
| Courts | GET | `/courts/{id}` | Consulta quadra |
| Courts | PUT | `/courts/{id}` | Atualiza quadra |
| Courts | DELETE | `/courts/{id}` | Exclui quadra |
| Reservations | POST | `/reservations` | Cria reserva |
| Reservations | GET | `/reservations` | Lista reservas |
| Reservations | GET | `/reservations/{id}` | Consulta reserva |
| Reservations | GET | `/reservations/client/{client_id}` | Reservas do cliente |
| Reservations | GET | `/reservations/provider/{provider_id}` | Reservas do prestador |
| Reservations | GET | `/reservations/status/{status}` | Reservas por status |
| Reservations | PUT | `/reservations/{id}/accept` | Aceita reserva |
| Reservations | PUT | `/reservations/{id}/reject` | Recusa reserva |
| Reservations | PUT | `/reservations/{id}/cancel` | Cancela reserva |
| Reservations | PUT | `/reservations/{id}/finish` | Finaliza reserva |

---

# 14. Observações finais

Esta documentação representa a versão final da API REST do HubArena até a Sprint 4.

A comunicação assíncrona deve ser validada com o RabbitMQ e o consumer em execução. A evidência principal para a avaliação consiste em demonstrar que, ao criar uma reserva, o backend publica um evento e o prestador recebe a atualização sem precisar atualizar manualmente a tela.
