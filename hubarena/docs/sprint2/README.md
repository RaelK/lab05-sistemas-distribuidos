# Sprint 2 — Integração com Middleware Orientado a Mensagens

## Projeto

HubArena — plataforma para reserva de arenas e quadras esportivas.

Esta Sprint integra o backend Flask com um Middleware Orientado a Mensagens usando RabbitMQ. O objetivo é demonstrar comunicação assíncrona orientada a eventos entre o backend e um consumidor independente.

A implementação mantém a estrutura original do projeto. A nova camada foi adicionada em:

backend/app/messaging/

A documentação da Sprint 2 foi organizada em:

docs/sprint2/

---

## 1. Objetivo da Sprint

Integrar o MOM ao sistema, implementando comunicação assíncrona entre componentes do backend.

Foram implementados:

- RabbitMQ configurado via Docker Compose;
- backend Flask conectado ao RabbitMQ;
- endpoint de verificação do RabbitMQ;
- produtor de eventos no backend;
- consumidor assíncrono independente;
- publicação de eventos em dois momentos do fluxo de reserva;
- documentação dos eventos;
- relatório de integração.

---

## 2. Estrutura preservada do projeto

A estrutura principal foi mantida:

hubarena/
- backend/
  - app/
    - config/
    - controllers/
    - database/
    - messaging/
    - models/
    - repositories/
    - routes/
    - services/
  - docker-compose.yml
  - requirements.txt
  - run.py
- docs/
  - sprint1/
  - sprint2/
- postman/

A pasta criada para mensageria foi:

backend/app/messaging/

Arquivos principais da Sprint 2:

- backend/app/messaging/rabbitmq_client.py
- backend/app/messaging/event_publisher.py
- backend/app/messaging/reservation_consumer.py

---

## 3. MOM utilizado

Ferramenta escolhida:

RabbitMQ

Biblioteca Python:

pika==1.3.2

Imagem Docker:

rabbitmq:3-management

Portas:

- 5672: comunicação AMQP
- 15672: painel web do RabbitMQ

---

## 4. Fila utilizada

Fila:

hubarena.reservations.events

Essa fila recebe os eventos de reserva publicados pelo backend.

---

## 5. Eventos implementados

Foram implementados dois eventos:

1. reservation.created

Publicado quando uma nova reserva é criada com sucesso.

2. reservation.status_changed

Publicado quando uma reserva pendente é aceita ou recusada.

---

## 6. Como executar

Na pasta backend, subir os containers:

docker compose up -d

Verificar:

docker compose ps

O esperado é que apareçam:

- hubarena-postgres
- hubarena-rabbitmq

Acessar o painel do RabbitMQ:

http://localhost:15672

Credenciais:

usuário: hubarena
senha: hubarena_pass

No painel, verificar a fila:

hubarena.reservations.events

---

## 7. Rodar o backend

Na pasta backend, ativar o ambiente virtual:

source .venv/Scripts/activate

Rodar o backend Flask:

python run.py

O backend deve ficar disponível em:

http://127.0.0.1:5000

---

## 8. Rodar o consumidor assíncrono

Abrir outro terminal na pasta backend e executar:

source .venv/Scripts/activate
python -m app.messaging.reservation_consumer

O terminal deve exibir:

[ReservationConsumer] Consumidor iniciado.
[ReservationConsumer] Aguardando eventos na fila: hubarena.reservations.events

---

## 9. Testes pelo Postman

Todos os testes devem ser feitos pelo Postman.

Criar uma pasta na collection chamada:

Sprint 2 - MOM

Requests recomendados:

GET http://127.0.0.1:5000/health

GET http://127.0.0.1:5000/health/db

GET http://127.0.0.1:5000/health/rabbitmq

GET http://127.0.0.1:5000/users

GET http://127.0.0.1:5000/courts

GET http://127.0.0.1:5000/reservations

POST http://127.0.0.1:5000/reservations

PUT http://127.0.0.1:5000/reservations/{id}/accept

PUT http://127.0.0.1:5000/reservations/{id}/reject

---

## 10. Teste do RabbitMQ

Request:

GET http://127.0.0.1:5000/health/rabbitmq

Resposta esperada:

{
  "queue": "hubarena.reservations.events",
  "rabbitmq": "connected",
  "status": "ok"
}

Esse teste comprova que o backend está conectado ao RabbitMQ.

---

## 11. Teste do evento reservation.created

Request:

POST http://127.0.0.1:5000/reservations

Body de exemplo:

{
  "clientId": 2,
  "courtId": 1,
  "date": "2026-06-20",
  "startTime": "10:00",
  "endTime": "11:00"
}

Resposta esperada:

HTTP 201 Created

No terminal do Flask deve aparecer:

[EventPublisher] Evento publicado: reservation.created

No terminal do consumidor deve aparecer:

[ReservationConsumer] Evento recebido: reservation.created
[ReservationConsumer] Nova reserva recebida.
[ReservationConsumer] Mensagem processada e confirmada com ACK.

---

## 12. Teste do evento reservation.status_changed

Usar o ID de uma reserva pendente.

Aceitar reserva:

PUT http://127.0.0.1:5000/reservations/{id}/accept

Ou recusar reserva:

PUT http://127.0.0.1:5000/reservations/{id}/reject

Resposta esperada:

HTTP 200 OK

No terminal do Flask deve aparecer:

[EventPublisher] Evento publicado: reservation.status_changed

No terminal do consumidor deve aparecer:

[ReservationConsumer] Evento recebido: reservation.status_changed
[ReservationConsumer] Alteração de status recebida.
[ReservationConsumer] Mensagem processada e confirmada com ACK.

---

## 13. Demonstração de assincronicidade

A comunicação assíncrona é demonstrada com três partes rodando separadamente:

1. Postman enviando requisição REST ao backend.
2. Backend Flask publicando evento no RabbitMQ.
3. Consumidor recebendo o evento pela fila.

Fluxo:

Postman -> Backend Flask -> RabbitMQ -> ReservationConsumer

O consumidor não possui rota HTTP. Ele não é chamado diretamente pelo Postman nem pelo backend via REST. Ele recebe mensagens exclusivamente pelo RabbitMQ.

---

## 14. Evidências para o professor

Para comprovar a Sprint 2, recomenda-se apresentar:

1. Docker Compose com PostgreSQL e RabbitMQ em execução.
2. Painel RabbitMQ aberto em http://localhost:15672.
3. Fila hubarena.reservations.events criada.
4. Postman retornando 200 em /health/rabbitmq.
5. Postman retornando 201 ao criar reserva.
6. Terminal Flask mostrando publicação de reservation.created.
7. Terminal consumidor mostrando consumo de reservation.created.
8. Postman retornando 200 ao aceitar ou recusar reserva.
9. Terminal consumidor mostrando consumo de reservation.status_changed.

---

## 15. Critérios atendidos

MOM funcionando corretamente:

RabbitMQ configurado via Docker Compose, painel web ativo e endpoint /health/rabbitmq funcionando.

Produtor e consumidor:

Produtor implementado em event_publisher.py e consumidor implementado em reservation_consumer.py.

Documentação dos eventos:

Arquivo docs/sprint2/eventos_mom.md.

Demonstração de assincronicidade:

Backend e consumidor rodam em processos separados e se comunicam via RabbitMQ.

Relatório de integração:

Arquivo docs/sprint2/relatorio_integracao_mom.md.