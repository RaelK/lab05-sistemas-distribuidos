# HubArena - Documentação das Coleções Postman

Este diretório contém as coleções Postman utilizadas para testar o backend REST do projeto HubArena.

## Arquivos disponíveis

```text
postman/HubArena_Sprint1.postman_collection.json
postman/HubArena_Sprint2.postman_collection.json
postman/Readme.md
```

## Coleção da Sprint 2

Arquivo:

```text
HubArena_Sprint2.postman_collection.json
```

A coleção da Sprint 2 valida a integração com RabbitMQ e os eventos de reserva:

```text
reservation.created
reservation.status_changed
```

## Como preparar a aplicação

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

## RabbitMQ Management

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

## Ordem recomendada no Postman

1. GET Health API
2. GET Health DB
3. GET Health RabbitMQ
4. GET Users
5. GET Courts
6. GET Reservations
7. Se o banco estiver vazio, executar a pasta "Setup opcional se o banco estiver vazio"
8. POST Create Reservation - publica reservation.created
9. PUT Accept Reservation - publica reservation.status_changed
10. POST Create Reservation for Reject - publica reservation.created
11. PUT Reject Reservation - publica reservation.status_changed

## Evidências esperadas

- `GET /health/rabbitmq` retorna status 200.
- RabbitMQ mostra a fila `hubarena.reservations.events`.
- O terminal do Flask mostra `[EventPublisher] Evento publicado: reservation.created`.
- O terminal do consumidor mostra `[ReservationConsumer] Evento recebido: reservation.created`.
- O terminal do Flask mostra `[EventPublisher] Evento publicado: reservation.status_changed`.
- O terminal do consumidor mostra `[ReservationConsumer] Evento recebido: reservation.status_changed`.

## Observações

- O consumidor não possui endpoint REST.
- O consumidor roda em terminal separado.
- A comunicação entre backend e consumidor ocorre exclusivamente pelo RabbitMQ.
- Se houver conflito de horário, altere a data ou o horário no body da reserva.
