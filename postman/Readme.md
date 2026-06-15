# HubArena - Documentação das Coleções Postman

Este diretório contém as coleções Postman utilizadas para validar os endpoints REST e a integração assíncrona implementados no projeto **HubArena**.

As coleções documentam e organizam os endpoints responsáveis por:

- verificação da API;
- verificação da conexão com PostgreSQL;
- cadastro e consulta de usuários;
- cadastro e consulta de arenas;
- cadastro e consulta de quadras;
- criação e gerenciamento de reservas;
- integração com RabbitMQ;
- publicação e consumo de eventos.

---

# Estrutura das Coleções

## Sprint 1

Arquivo principal:

```text
HubArena_Sprint1.postman_collection.json
```

Responsável pelos testes da API REST principal do sistema.

---

## Sprint 2

Arquivo principal:

```text
HubArena_Sprint2.postman_collection.json
```

Responsável pelos testes de integração assíncrona com RabbitMQ.

---

# Sprint 1 - API REST

A coleção da Sprint 1 documenta e organiza os endpoints responsáveis por:

- verificação da API;
- verificação da conexão com PostgreSQL;
- cadastro e consulta de usuários;
- cadastro e consulta de arenas;
- cadastro e consulta de quadras;
- criação e gerenciamento de reservas.

---

# 1. Como importar a coleção no Postman

1. Abra o Postman.
2. Clique em **Import**.
3. Selecione o arquivo:

```text
postman/HubArena_Sprint1.postman_collection.json
```

4. Confirme a importação.
5. Execute as requisições na ordem recomendada ao final deste documento.

---

# 2. URL base da API

A API deve estar rodando localmente em:

```text
http://127.0.0.1:5000
```

Antes de executar os testes no Postman, entre na pasta do backend e inicie o ambiente:

```bash
cd backend
docker compose up -d
source venv/bin/activate
python init_db.py
python run.py
```

---

# 3. Organização dos Endpoints

A coleção está organizada nos seguintes grupos:

```text
Health
Users
Arenas
Courts
Reservations
```

---

# 4. Health

Os endpoints de Health são usados para verificar se o backend Flask está ativo e se a conexão com o PostgreSQL está funcionando corretamente.

---

## 4.1 GET /health

Verifica se a API está rodando.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/health
```

### Corpo da requisição

Não possui corpo.

### Resposta esperada

```json
{
  "message": "HubArena API is running",
  "status": "ok"
}
```

### Status HTTP esperado

```text
200 OK
```

---

## 4.2 GET /health/db

Verifica se o backend consegue se conectar ao banco PostgreSQL.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/health/db
```

### Corpo da requisição

Não possui corpo.

### Resposta esperada

```json
{
  "database": "PostgreSQL connected",
  "status": "ok"
}
```

### Status HTTP esperado

```text
200 OK
```

---

# 5. Users

Os endpoints de `Users` são responsáveis pelo cadastro e consulta de usuários da plataforma.

O sistema possui dois perfis de usuário:

| Role | Descrição |
|---|---|
| `CLIENT` | Cliente que solicita reservas de quadras |
| `PROVIDER` | Prestador que cadastra arenas, gerencia quadras e aprova ou recusa reservas |

---

## 5.1 POST /users - Create Provider

Cria um usuário do tipo prestador.

O prestador representa o administrador de uma arena esportiva.

### Método

```http
POST
```

### URL

```http
http://127.0.0.1:5000/users
```

### Headers

| Chave | Valor |
|---|---|
| Content-Type | application/json |

### Body

```json
{
  "name": "Arena Pampulha",
  "email": "prestador@hubarena.com",
  "password": "123456",
  "role": "PROVIDER"
}
```

### Campos

| Campo | Tipo | Descrição |
|---|---|---|
| `name` | string | Nome do prestador ou estabelecimento |
| `email` | string | E-mail único do usuário |
| `password` | string | Senha do usuário |
| `role` | string | Tipo do usuário, neste caso `PROVIDER` |

### Resposta esperada

```json
{
  "id": 1,
  "name": "Arena Pampulha",
  "email": "prestador@hubarena.com",
  "role": "PROVIDER",
  "createdAt": "2026-05-10T09:35:45.767610"
}
```

### Status HTTP esperado

```text
201 Created
```

### Possíveis erros

Se o e-mail já estiver cadastrado:

```json
{
  "error": "Já existe um usuário com este e-mail."
}
```

---

## 5.2 POST /users - Create Client

Cria um usuário do tipo cliente.

O cliente representa o usuário final que poderá solicitar reservas de quadras.

### Método

```http
POST
```

### URL

```http
http://127.0.0.1:5000/users
```

### Headers

| Chave | Valor |
|---|---|
| Content-Type | application/json |

### Body

```json
{
  "name": "Jose Cliente",
  "email": "cliente@hubarena.com",
  "password": "123456",
  "role": "CLIENT"
}
```

### Campos

| Campo | Tipo | Descrição |
|---|---|---|
| `name` | string | Nome do cliente |
| `email` | string | E-mail único do usuário |
| `password` | string | Senha do usuário |
| `role` | string | Tipo do usuário, neste caso `CLIENT` |

### Resposta esperada

```json
{
  "id": 2,
  "name": "Jose Cliente",
  "email": "cliente@hubarena.com",
  "role": "CLIENT",
  "createdAt": "2026-05-10T09:38:49.636689"
}
```

### Status HTTP esperado

```text
201 Created
```

---

## 5.3 GET /users - List Users

Lista todos os usuários cadastrados no sistema.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/users
```

### Corpo da requisição

Não possui corpo.

### Status HTTP esperado

```text
200 OK
```

---

## 5.4 GET /users/{id} - Get User By ID

Consulta um usuário específico pelo identificador.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/users/1
```

### Status HTTP esperado

```text
200 OK
```

---

# 6. Arenas

Os endpoints de `Arenas` são responsáveis pelo cadastro e consulta dos estabelecimentos esportivos.

Uma arena representa o local administrado por um prestador. Uma arena pode possuir várias quadras.

---

## 6.1 POST /arenas - Create Arena

Cria uma nova arena vinculada a um usuário do tipo `PROVIDER`.

### Método

```http
POST
```

### URL

```http
http://127.0.0.1:5000/arenas
```

### Body

```json
{
  "providerId": 1,
  "name": "HubArena Pampulha",
  "description": "Arena esportiva com quadras de futebol society e futsal.",
  "address": "Avenida Antonio Carlos, Belo Horizonte - MG"
}
```

### Status HTTP esperado

```text
201 Created
```

---

## 6.2 GET /arenas - List Arenas

Lista todas as arenas cadastradas.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/arenas
```

### Status HTTP esperado

```text
200 OK
```

---

## 6.3 GET /arenas/{id} - Get Arena By ID

Consulta uma arena específica pelo identificador.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/arenas/1
```

### Status HTTP esperado

```text
200 OK
```

---

# 7. Courts

Os endpoints de `Courts` são responsáveis pelo cadastro e consulta das quadras esportivas.

---

## 7.1 POST /courts - Create Court

Cria uma nova quadra vinculada a uma arena.

### Método

```http
POST
```

### URL

```http
http://127.0.0.1:5000/courts
```

### Body

```json
{
  "arenaId": 1,
  "sport": "Futebol Society",
  "priceHour": 120.0,
  "capacity": 10,
  "available": true
}
```

### Status HTTP esperado

```text
201 Created
```

---

## 7.2 GET /courts - List Courts

Lista todas as quadras cadastradas.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/courts
```

### Status HTTP esperado

```text
200 OK
```

---

## 7.3 GET /courts/{id} - Get Court By ID

Consulta uma quadra específica pelo identificador.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/courts/1
```

### Status HTTP esperado

```text
200 OK
```

---

# 8. Reservations

Os endpoints de `Reservations` são responsáveis pelo fluxo principal de reserva de quadras.

Uma reserva é criada por um cliente para uma quadra específica. Inicialmente, a reserva é criada com status `PENDING`. Em seguida, o prestador pode aceitar ou recusar a solicitação.

---

## Status utilizados na Sprint 1

| Status | Descrição |
|---|---|
| `PENDING` | Reserva criada e aguardando decisão do prestador |
| `ACCEPTED` | Reserva aceita pelo prestador |
| `REJECTED` | Reserva recusada pelo prestador |

---

## 8.1 POST /reservations - Create Reservation

Cria uma nova solicitação de reserva.

### Método

```http
POST
```

### URL

```http
http://127.0.0.1:5000/reservations
```

### Body

```json
{
  "clientId": 2,
  "courtId": 1,
  "date": "2026-05-15",
  "startTime": "19:00",
  "endTime": "20:00"
}
```

### Status HTTP esperado

```text
201 Created
```

---

## 8.2 GET /reservations - List Reservations

Lista todas as reservas cadastradas.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/reservations
```

### Status HTTP esperado

```text
200 OK
```

---

## 8.3 GET /reservations/{id} - Get Reservation By ID

Consulta uma reserva específica pelo identificador.

### Método

```http
GET
```

### URL

```http
http://127.0.0.1:5000/reservations/1
```

### Status HTTP esperado

```text
200 OK
```

---

## 8.4 PUT /reservations/{id}/accept - Accept Reservation

Atualiza o status de uma reserva pendente para `ACCEPTED`.

### Método

```http
PUT
```

### URL

```http
http://127.0.0.1:5000/reservations/1/accept
```

### Status HTTP esperado

```text
200 OK
```

---

## 8.5 PUT /reservations/{id}/reject - Reject Reservation

Atualiza o status de uma reserva pendente para `REJECTED`.

### Método

```http
PUT
```

### URL

```http
http://127.0.0.1:5000/reservations/1/reject
```

### Status HTTP esperado

```text
200 OK
```

---

# 9. Ordem recomendada de execução - Sprint 1

1. `GET /health`
2. `GET /health/db`
3. `POST /users` criando um `PROVIDER`
4. `POST /users` criando um `CLIENT`
5. `GET /users`
6. `GET /users/{id}`
7. `POST /arenas`
8. `GET /arenas`
9. `GET /arenas/{id}`
10. `POST /courts`
11. `GET /courts`
12. `GET /courts/{id}`
13. `POST /reservations`
14. `GET /reservations`
15. `GET /reservations/{id}`
16. `PUT /reservations/{id}/accept`
17. `PUT /reservations/{id}/reject`

---

# 10. Observações importantes - Sprint 1

- Se um e-mail já existir, o endpoint `POST /users` retornará erro informando que já existe um usuário com este e-mail.
- O endpoint `POST /reservations` valida conflito de horário para evitar reservas simultâneas na mesma quadra.
- Para repetir os testes do zero, pode-se recriar o banco ou usar e-mails diferentes.
- O script `backend/scripts/api_smoke_test.py` executa automaticamente o fluxo principal da API.
- O relatório gerado pelo teste automatizado está em:

```text
backend/docs/api_test_results.md
```

- A cópia consolidada do relatório da Sprint 1 está em:

```text
docs/sprint1/api_test_results.md
```

---

# 11. Relação dos endpoints da Sprint 1

| Grupo | Método | Endpoint | Descrição |
|---|---|---|---|
| Health | GET | `/health` | Verifica se a API está ativa |
| Health | GET | `/health/db` | Verifica conexão com PostgreSQL |
| Users | POST | `/users` | Cria cliente ou prestador |
| Users | GET | `/users` | Lista usuários |
| Users | GET | `/users/{id}` | Consulta usuário por ID |
| Arenas | POST | `/arenas` | Cria arena |
| Arenas | GET | `/arenas` | Lista arenas |
| Arenas | GET | `/arenas/{id}` | Consulta arena por ID |
| Courts | POST | `/courts` | Cria quadra |
| Courts | GET | `/courts` | Lista quadras |
| Courts | GET | `/courts/{id}` | Consulta quadra por ID |
| Reservations | POST | `/reservations` | Cria reserva |
| Reservations | GET | `/reservations` | Lista reservas |
| Reservations | GET | `/reservations/{id}` | Consulta reserva por ID |
| Reservations | PUT | `/reservations/{id}/accept` | Aceita reserva pendente |
| Reservations | PUT | `/reservations/{id}/reject` | Recusa reserva pendente |

---

# Sprint 2 - RabbitMQ e Eventos

A coleção da Sprint 2 valida a integração com RabbitMQ e os eventos de reserva publicados pela aplicação.

Eventos monitorados:

```text
reservation.created
reservation.status_changed
```

---

# 12. Como importar a coleção da Sprint 2

1. Abra o Postman.
2. Clique em **Import**.
3. Selecione o arquivo:

```text
postman/HubArena_Sprint2.postman_collection.json
```

4. Confirme a importação.

---

# 13. Como preparar a aplicação

Na pasta `hubarena/backend`:

```bash
docker compose up -d
source .venv/Scripts/activate
pip install -r requirements.txt
python run.py
```

Em outro terminal, também em `hubarena/backend`:

```bash
source .venv/Scripts/activate
python -m app.messaging.reservation_consumer
```

---

# 14. RabbitMQ Management

Painel:

```text
http://localhost:15672
```

Credenciais:

```text
usuário: hubarena
senha: hubarena_pass
```

Fila:

```text
hubarena.reservations.events
```

---

# 15. Organização dos Endpoints - Sprint 2

A coleção está organizada nos seguintes grupos:

```text
Health
Users
Courts
Reservations
RabbitMQ
Setup opcional se o banco estiver vazio
```

---

# 16. Ordem recomendada de execução - Sprint 2

1. `GET Health API`
2. `GET Health DB`
3. `GET Health RabbitMQ`
4. `GET Users`
5. `GET Courts`
6. `GET Reservations`
7. Se o banco estiver vazio, executar:
   - `Setup opcional se o banco estiver vazio`
8. `POST Create Reservation - publica reservation.created`
9. `PUT Accept Reservation - publica reservation.status_changed`
10. `POST Create Reservation for Reject - publica reservation.created`
11. `PUT Reject Reservation - publica reservation.status_changed`

---

# 17. Evidências esperadas - Sprint 2

- `GET /health/rabbitmq` retorna status `200 OK`.
- RabbitMQ mostra a fila `hubarena.reservations.events`.
- O terminal do Flask mostra:

```text
[EventPublisher] Evento publicado: reservation.created
```

- O terminal do consumidor mostra:

```text
[ReservationConsumer] Evento recebido: reservation.created
```

- O terminal do Flask mostra:

```text
[EventPublisher] Evento publicado: reservation.status_changed
```

- O terminal do consumidor mostra:

```text
[ReservationConsumer] Evento recebido: reservation.status_changed
```

---

# 18. Observações importantes - Sprint 2

- O consumidor não possui endpoint REST.
- O consumidor roda em terminal separado.
- A comunicação entre backend e consumidor ocorre exclusivamente pelo RabbitMQ.
- Se houver conflito de horário, altere a data ou o horário no body da reserva.

---

# 19. Relação dos endpoints da Sprint 2

| Grupo | Método | Endpoint | Descrição |
|---|---|---|---|
| Health | GET | `/health` | Verifica se a API está ativa |
| Health | GET | `/health/db` | Verifica conexão PostgreSQL |
| Health | GET | `/health/rabbitmq` | Verifica conexão RabbitMQ |
| Reservations | POST | `/reservations` | Cria reserva e publica evento |
| Reservations | PUT | `/reservations/{id}/accept` | Aceita reserva e publica evento |
| Reservations | PUT | `/reservations/{id}/reject` | Recusa reserva e publica evento |
