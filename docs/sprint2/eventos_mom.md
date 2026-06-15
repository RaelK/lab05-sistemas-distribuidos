# Documentação dos Eventos MOM — Sprint 2

## 1. Visão geral

Esta documentação descreve os eventos publicados pelo backend do HubArena na Sprint 2.

O backend Flask atua como produtor de eventos. O RabbitMQ atua como broker de mensagens. O consumidor assíncrono ReservationConsumer processa as mensagens recebidas da fila.

A comunicação segue o fluxo:

Postman -> Backend Flask -> RabbitMQ -> ReservationConsumer

O consumidor não é chamado diretamente por REST. Ele recebe mensagens exclusivamente pela fila RabbitMQ.

---

## 2. Broker utilizado

MOM utilizado:

RabbitMQ

Biblioteca Python:

pika==1.3.2

Fila utilizada:

hubarena.reservations.events

Padrão utilizado:

Fila de eventos / Work Queue

---

## 3. Tabela dos eventos

| Evento | Momento de publicação | Produtor | Consumidor | Fila | Descrição |
|---|---|---|---|---|---|
| reservation.created | Após a criação de uma reserva | hubarena-backend | ReservationConsumer | hubarena.reservations.events | Informa que uma nova reserva foi criada no sistema. |
| reservation.status_changed | Após aceite ou recusa de uma reserva | hubarena-backend | ReservationConsumer | hubarena.reservations.events | Informa que o status de uma reserva foi alterado. |

---

## 4. Envelope padrão das mensagens

Todos os eventos publicados seguem o mesmo formato geral:

{
  "event": "nome.do.evento",
  "producer": "hubarena-backend",
  "occurredAt": "2026-05-25T10:00:00.000000+00:00",
  "payload": {}
}

Descrição dos campos:

| Campo | Tipo | Descrição |
|---|---|---|
| event | string | Nome do evento de domínio. |
| producer | string | Componente que publicou o evento. |
| occurredAt | string | Data e hora da publicação no formato ISO 8601 em UTC. |
| payload | object | Dados específicos do evento. |

---

## 5. Evento reservation.created

### 5.1 Quando ocorre

O evento reservation.created ocorre quando uma nova reserva é criada com sucesso pelo endpoint:

POST /reservations

Esse evento é publicado depois que a reserva é salva no banco de dados.

---

### 5.2 Produtor

Arquivo responsável pela publicação:

backend/app/messaging/event_publisher.py

O publicador é chamado a partir do serviço:

backend/app/services/reservation_service.py

Método:

create_reservation

---

### 5.3 Consumidor

Arquivo consumidor:

backend/app/messaging/reservation_consumer.py

Método de processamento:

process_reservation_created

---

### 5.4 Payload JSON de exemplo

{
  "event": "reservation.created",
  "producer": "hubarena-backend",
  "occurredAt": "2026-05-25T10:00:00.000000+00:00",
  "payload": {
    "id": 5,
    "clientId": 2,
    "courtId": 1,
    "date": "2026-06-20",
    "startTime": "10:00",
    "endTime": "11:00",
    "status": "PENDING",
    "createdAt": "2026-05-25T10:00:00.000000",
    "updatedAt": "2026-05-25T10:00:00.000000"
  }
}

---

### 5.5 Ação executada pelo consumidor

O consumidor simula a notificação ao prestador informando que uma nova reserva foi criada.

Exemplo de saída esperada no terminal do consumidor:

[ReservationConsumer] Evento recebido: reservation.created
[ReservationConsumer] Nova reserva recebida.
[ReservationConsumer] Reserva ID: 5
[ReservationConsumer] Cliente ID: 2
[ReservationConsumer] Quadra ID: 1
[ReservationConsumer] Ação simulada: notificar prestador sobre nova reserva.
[ReservationConsumer] Mensagem processada e confirmada com ACK.

---

## 6. Evento reservation.status_changed

### 6.1 Quando ocorre

O evento reservation.status_changed ocorre quando uma reserva pendente é aceita ou recusada.

Endpoints relacionados:

PUT /reservations/{id}/accept

PUT /reservations/{id}/reject

Esse evento é publicado depois que o novo status é salvo no banco de dados.

---

### 6.2 Produtor

Arquivo responsável pela publicação:

backend/app/messaging/event_publisher.py

O publicador é chamado a partir do serviço:

backend/app/services/reservation_service.py

Métodos:

accept_reservation

reject_reservation

---

### 6.3 Consumidor

Arquivo consumidor:

backend/app/messaging/reservation_consumer.py

Método de processamento:

process_reservation_status_changed

---

### 6.4 Payload JSON de exemplo — aceite

{
  "event": "reservation.status_changed",
  "producer": "hubarena-backend",
  "occurredAt": "2026-05-25T10:05:00.000000+00:00",
  "payload": {
    "reservation": {
      "id": 5,
      "clientId": 2,
      "courtId": 1,
      "date": "2026-06-20",
      "startTime": "10:00",
      "endTime": "11:00",
      "status": "ACCEPTED",
      "createdAt": "2026-05-25T10:00:00.000000",
      "updatedAt": "2026-05-25T10:05:00.000000"
    },
    "previousStatus": "PENDING",
    "newStatus": "ACCEPTED"
  }
}

---

### 6.5 Payload JSON de exemplo — recusa

{
  "event": "reservation.status_changed",
  "producer": "hubarena-backend",
  "occurredAt": "2026-05-25T10:10:00.000000+00:00",
  "payload": {
    "reservation": {
      "id": 6,
      "clientId": 2,
      "courtId": 1,
      "date": "2026-06-21",
      "startTime": "10:00",
      "endTime": "11:00",
      "status": "REJECTED",
      "createdAt": "2026-05-25T10:08:00.000000",
      "updatedAt": "2026-05-25T10:10:00.000000"
    },
    "previousStatus": "PENDING",
    "newStatus": "REJECTED"
  }
}

---

### 6.6 Ação executada pelo consumidor

O consumidor simula a notificação ao cliente informando que a reserva teve o status alterado.

Exemplo de saída esperada no terminal do consumidor:

[ReservationConsumer] Evento recebido: reservation.status_changed
[ReservationConsumer] Alteração de status recebida.
[ReservationConsumer] Reserva ID: 5
[ReservationConsumer] Status anterior: PENDING
[ReservationConsumer] Novo status: ACCEPTED
[ReservationConsumer] Ação simulada: notificar cliente sobre mudança de status.
[ReservationConsumer] Mensagem processada e confirmada com ACK.

---

## 7. Garantias de mensageria utilizadas

A implementação usa os seguintes recursos do RabbitMQ:

| Recurso | Uso na implementação | Finalidade |
|---|---|---|
| durable=true | Declaração da fila | Mantém a fila registrada no broker. |
| delivery_mode=2 | Publicação da mensagem | Publica mensagens como persistentes. |
| basic_ack | Consumidor | Confirma que a mensagem foi processada. |
| basic_nack | Consumidor | Sinaliza falha no processamento. |
| prefetch_count=1 | Consumidor | Processa uma mensagem por vez. |

---

## 8. Como verificar no RabbitMQ

Acessar:

http://localhost:15672

Credenciais:

usuário: hubarena

senha: hubarena_pass

Verificar em:

Queues and Streams

Fila esperada:

hubarena.reservations.events

Durante os testes, é possível observar mensagens sendo publicadas e consumidas nessa fila.

---

## 9. Como demonstrar para avaliação

Para demonstrar a comunicação assíncrona:

1. Abrir o backend Flask em um terminal.
2. Abrir o consumidor em outro terminal.
3. Enviar uma requisição pelo Postman para criar uma reserva.
4. Observar o backend publicando reservation.created.
5. Observar o consumidor recebendo reservation.created.
6. Enviar uma requisição pelo Postman para aceitar ou recusar uma reserva.
7. Observar o backend publicando reservation.status_changed.
8. Observar o consumidor recebendo reservation.status_changed.

Isso comprova que o consumidor processa mensagens sem chamada REST direta.