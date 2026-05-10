# HubArena - Arquitetura do Sistema

A arquitetura do HubArena foi planejada como uma aplicação distribuída orientada a eventos. Na Sprint 1, foi implementado o backend REST com persistência em PostgreSQL. A arquitetura já prevê a integração com RabbitMQ, que será desenvolvida na Sprint 2.

## Diagrama PlantUML

O diagrama principal está no arquivo:

docs/architecture.puml

## Componentes

### App Cliente Flutter

Aplicativo móvel utilizado pelo cliente para buscar arenas, visualizar quadras disponíveis e criar reservas.

### App Prestador Flutter

Aplicativo móvel utilizado pelo prestador para gerenciar arenas, quadras e solicitações de reserva.

### Backend REST Flask

Camada responsável por expor os endpoints REST, processar regras de negócio e acessar o banco de dados por meio do SQLAlchemy.

### PostgreSQL

Banco de dados relacional utilizado para armazenar usuários, arenas, quadras e reservas.

### RabbitMQ

Middleware orientado a mensagens previsto para a Sprint 2. Será utilizado para publicar e consumir eventos do domínio, como criação de reserva e atualização de status.

## Protocolos de comunicação

| Comunicação | Protocolo |
|---|---|
| App Cliente para Backend | HTTP REST / JSON |
| App Prestador para Backend | HTTP REST / JSON |
| Backend para PostgreSQL | SQL via SQLAlchemy |
| Backend para RabbitMQ | AMQP |
| RabbitMQ para consumidores | Eventos assíncronos |

## Eventos previstos

| Evento | Descrição |
|---|---|
| reservation_created | Nova reserva criada pelo cliente |
| reservation_accepted | Reserva aceita pelo prestador |
| reservation_rejected | Reserva recusada pelo prestador |

## Observação sobre a Sprint 1

Na Sprint 1, o RabbitMQ aparece no diagrama como componente arquitetural planejado. A implementação efetiva da comunicação assíncrona será realizada na Sprint 2.
