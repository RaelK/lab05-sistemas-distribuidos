# HubArena — Sprint 2
## Passo a passo de execução e teste da aplicação

Este documento começa a partir da etapa de execução da aplicação, considerando que a implementação da Sprint 2 já foi concluída no projeto.

A Sprint 2 integra o backend Flask do HubArena ao RabbitMQ, usando comunicação assíncrona orientada a eventos.

Eventos implementados:

- `reservation.created`
- `reservation.status_changed`

Fila RabbitMQ utilizada:

```text
hubarena.reservations.events
```

---

## 1. Preparar Terminal 1 — subir Docker

Abra o Git Bash e entre na pasta do backend:

```bash
cd /c/Users/jscas/OneDrive/Desktop/lab05-sistemas-distribuidos-push/hubarena/backend
```

Suba os containers:

```bash
docker compose up -d
```

Verifique se os containers estão rodando:

```bash
docker compose ps
```

Resultado esperado:

```text
hubarena-postgres    Up
hubarena-rabbitmq    Up
```

Esse passo sobe:

- PostgreSQL, usado como banco de dados;
- RabbitMQ, usado como Middleware Orientado a Mensagens.

Atenção: não use o comando abaixo, porque ele apaga volumes do Docker:

```bash
docker compose down -v
```

---

## 2. Acessar RabbitMQ Management

Abra o navegador e acesse:

```text
http://localhost:15672
```

Use as credenciais:

```text
Username: hubarena
Password: hubarena_pass
```

Depois de executar o endpoint `GET /health/rabbitmq`, a fila esperada será:

```text
hubarena.reservations.events
```

No painel do RabbitMQ, acesse:

```text
Queues and Streams
```

A evidência esperada é a fila `hubarena.reservations.events` criada.

---

## 3. Preparar ambiente Python

Ainda na pasta `hubarena/backend`, ative o ambiente virtual:

```bash
source .venv/Scripts/activate
```

Se a pasta `.venv` não existir, crie o ambiente:

```bash
py -3.13 -m venv .venv
source .venv/Scripts/activate
pip install -r requirements.txt
```

Teste se Flask e Pika estão instalados:

```bash
python -c "import flask; import pika; print('Flask e Pika OK')"
```

Resultado esperado:

```text
Flask e Pika OK
```

---

## 4. Rodar backend Flask — Terminal 1

Com o ambiente virtual ativado, execute:

```bash
python run.py
```

Resultado esperado:

```text
Running on http://127.0.0.1:5000
```

Mantenha esse terminal aberto.

Esse terminal mostrará os logs do backend Flask e também as mensagens do publicador de eventos.

Exemplo esperado durante os testes:

```text
[EventPublisher] Evento publicado: reservation.created
[EventPublisher] Evento publicado: reservation.status_changed
```

---

## 5. Rodar consumidor assíncrono — Terminal 2

Abra outro Git Bash.

Entre novamente na pasta do backend:

```bash
cd /c/Users/jscas/OneDrive/Desktop/lab05-sistemas-distribuidos-push/hubarena/backend
```

Ative o ambiente virtual:

```bash
source .venv/Scripts/activate
```

Rode o consumidor:

```bash
python -m app.messaging.reservation_consumer
```

Resultado esperado:

```text
[ReservationConsumer] Consumidor iniciado.
[ReservationConsumer] Aguardando eventos na fila: hubarena.reservations.events
```

Mantenha esse terminal aberto.

Esse consumidor não possui endpoint REST. Ele recebe mensagens exclusivamente pela fila do RabbitMQ.

---

## 6. Abrir ou importar a coleção Postman

No Postman, importe a coleção:

```text
hubarena/postman/HubArena_Sprint2.postman_collection.json
```

A coleção deve conter os grupos:

```text
1 - Health e MOM
2 - Verificação de dados existentes
3 - Setup opcional se o banco estiver vazio
4 - Eventos Sprint 2
```

---

## 7. Teste 1 — verificar API Flask

No Postman:

```http
GET http://127.0.0.1:5000/health
```

Resposta esperada:

```json
{
  "message": "HubArena API is running",
  "status": "ok"
}
```

Status HTTP esperado:

```text
200 OK
```

---

## 8. Teste 2 — verificar PostgreSQL

No Postman:

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

Status HTTP esperado:

```text
200 OK
```

---

## 9. Teste 3 — verificar RabbitMQ

No Postman:

```http
GET http://127.0.0.1:5000/health/rabbitmq
```

Resposta esperada:

```json
{
  "queue": "hubarena.reservations.events",
  "rabbitmq": "connected",
  "status": "ok"
}
```

Status HTTP esperado:

```text
200 OK
```

Depois desse teste, volte ao painel RabbitMQ:

```text
http://localhost:15672
```

Entre em:

```text
Queues and Streams
```

Verifique se a fila existe:

```text
hubarena.reservations.events
```

Essa é a principal evidência do critério: MOM funcionando corretamente.

---

## 10. Verificar dados existentes

Antes de criar uma reserva, verifique se existem usuários e quadras.

No Postman:

```http
GET http://127.0.0.1:5000/users
```

Procure um usuário com:

```text
role = CLIENT
```

No Postman:

```http
GET http://127.0.0.1:5000/courts
```

Procure uma quadra com:

```text
available = true
```

No banco usado durante o desenvolvimento, os IDs usados eram:

```text
clientId: 2
courtId: 1
```

Se esses registros não existirem, execute a pasta da coleção:

```text
3 - Setup opcional se o banco estiver vazio
```

---

## 11. Setup opcional se o banco estiver vazio

Execute apenas se `GET /users` e `GET /courts` retornarem listas vazias.

### 11.1 Criar Provider

```http
POST http://127.0.0.1:5000/users
```

Body:

```json
{
  "name": "Arena Pampulha",
  "email": "prestador_123@hubarena.com",
  "password": "123456",
  "role": "PROVIDER"
}
```

Guarde o ID retornado como `providerId`.

---

### 11.2 Criar Client

```http
POST http://127.0.0.1:5000/users
```

Body:

```json
{
  "name": "Jose Cliente",
  "email": "cliente_123@hubarena.com",
  "password": "123456",
  "role": "CLIENT"
}
```

Guarde o ID retornado como `clientId`.

---

### 11.3 Criar Arena

```http
POST http://127.0.0.1:5000/arenas
```

Body:

```json
{
  "providerId": 1,
  "name": "HubArena Pampulha",
  "description": "Arena esportiva com quadras de futebol society e futsal.",
  "address": "Avenida Antonio Carlos, Belo Horizonte - MG"
}
```

Use no campo `providerId` o ID correto do usuário `PROVIDER`.

Guarde o ID retornado como `arenaId`.

---

### 11.4 Criar Court

```http
POST http://127.0.0.1:5000/courts
```

Body:

```json
{
  "arenaId": 1,
  "sport": "Futebol Society",
  "priceHour": 120.0,
  "capacity": 10,
  "available": true
}
```

Use no campo `arenaId` o ID correto da arena.

Guarde o ID retornado como `courtId`.

---

## 12. Testar evento reservation.created

No Postman:

```http
POST http://127.0.0.1:5000/reservations
```

Body usando os dados do banco original:

```json
{
  "clientId": 2,
  "courtId": 1,
  "date": "2026-06-20",
  "startTime": "10:00",
  "endTime": "11:00"
}
```

Se você criou dados no setup opcional, substitua `clientId` e `courtId` pelos IDs corretos.

Resposta esperada:

```text
HTTP 201 Created
```

Guarde o ID da reserva criada.

No Terminal 1, backend Flask, deve aparecer:

```text
[EventPublisher] Evento publicado: reservation.created
```

No Terminal 2, consumidor, deve aparecer:

```text
[ReservationConsumer] Evento recebido: reservation.created
[ReservationConsumer] Nova reserva recebida.
[ReservationConsumer] Mensagem processada e confirmada com ACK.
```

Esse teste comprova que:

- o Postman chamou apenas o backend REST;
- o backend criou a reserva;
- o backend publicou o evento no RabbitMQ;
- o consumidor recebeu a mensagem pela fila;
- não houve chamada REST direta ao consumidor.

---

## 13. Testar evento reservation.status_changed — aceite

Use o ID da reserva criada no passo anterior.

Exemplo:

```http
PUT http://127.0.0.1:5000/reservations/5/accept
```

Resposta esperada:

```text
HTTP 200 OK
```

No Terminal 1, backend Flask, deve aparecer:

```text
[EventPublisher] Evento publicado: reservation.status_changed
```

No Terminal 2, consumidor, deve aparecer:

```text
[ReservationConsumer] Evento recebido: reservation.status_changed
[ReservationConsumer] Alteração de status recebida.
[ReservationConsumer] Mensagem processada e confirmada com ACK.
```

Esse teste comprova o segundo momento de publicação de evento no fluxo de negócio.

---

## 14. Testar evento reservation.status_changed — recusa

Para testar recusa, crie uma segunda reserva:

```http
POST http://127.0.0.1:5000/reservations
```

Body:

```json
{
  "clientId": 2,
  "courtId": 1,
  "date": "2026-06-21",
  "startTime": "10:00",
  "endTime": "11:00"
}
```

Guarde o ID retornado.

Depois recuse:

```http
PUT http://127.0.0.1:5000/reservations/ID_DA_RESERVA/reject
```

Resposta esperada:

```text
HTTP 200 OK
```

No Terminal 1:

```text
[EventPublisher] Evento publicado: reservation.status_changed
```

No Terminal 2:

```text
[ReservationConsumer] Evento recebido: reservation.status_changed
[ReservationConsumer] Alteração de status recebida.
[ReservationConsumer] Mensagem processada e confirmada com ACK.
```

---

## 15. Evidências que devem aparecer no vídeo

Mostre durante a gravação:

1. `docker compose ps` com `hubarena-postgres` e `hubarena-rabbitmq` em execução.
2. Painel RabbitMQ em `http://localhost:15672`.
3. Fila `hubarena.reservations.events`.
4. Postman retornando `200` em `/health/rabbitmq`.
5. Postman criando reserva com `201 Created`.
6. Terminal Flask mostrando `reservation.created`.
7. Terminal consumidor mostrando `reservation.created`.
8. Postman aceitando ou recusando reserva com `200 OK`.
9. Terminal Flask mostrando `reservation.status_changed`.
10. Terminal consumidor mostrando `reservation.status_changed`.

---

## 16. Comandos resumidos

Terminal 1:

```bash
cd /c/Users/jscas/OneDrive/Desktop/lab05-sistemas-distribuidos-push/hubarena/backend
docker compose up -d
docker compose ps
source .venv/Scripts/activate
python run.py
```

Terminal 2:

```bash
cd /c/Users/jscas/OneDrive/Desktop/lab05-sistemas-distribuidos-push/hubarena/backend
source .venv/Scripts/activate
python -m app.messaging.reservation_consumer
```

Navegador:

```text
http://localhost:15672
```

RabbitMQ:

```text
Username: hubarena
Password: hubarena_pass
```

Postman:

```http
GET http://127.0.0.1:5000/health
GET http://127.0.0.1:5000/health/db
GET http://127.0.0.1:5000/health/rabbitmq
POST http://127.0.0.1:5000/reservations
PUT http://127.0.0.1:5000/reservations/{id}/accept
PUT http://127.0.0.1:5000/reservations/{id}/reject
```
