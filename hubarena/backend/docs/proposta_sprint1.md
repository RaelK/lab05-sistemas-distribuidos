# Proposta de Domínio - HubArena - Sprint 1

## 1. Domínio escolhido

O HubArena é uma plataforma distribuída voltada para reserva de quadras esportivas. O sistema conecta clientes interessados em reservar espaços esportivos com prestadores responsáveis por arenas, quadras e horários disponíveis.

O domínio escolhido atende ao modelo cliente/prestador exigido pela disciplina, pois existe uma separação clara entre quem consome o serviço e quem administra a oferta. O cliente solicita reservas, enquanto o prestador cadastra arenas, gerencia quadras e aceita ou recusa solicitações.

## 2. Justificativa

A reserva de quadras esportivas ainda ocorre, em muitos casos, por mensagens, ligações telefônicas ou controles manuais. Esse processo pode gerar conflitos de horário, dificuldade de acompanhamento, baixa rastreabilidade e pouca transparência para clientes e prestadores.

O HubArena propõe centralizar esse fluxo em uma aplicação distribuída, com backend REST, persistência em PostgreSQL e arquitetura preparada para comunicação assíncrona via RabbitMQ nas próximas sprints. O projeto é viável para o escopo da disciplina porque permite evoluir progressivamente: primeiro com backend e banco de dados, depois com middleware orientado a mensagens e, por fim, com aplicativos móveis em Flutter.

## 3. Perfis de usuário

### Cliente

O cliente é o usuário final interessado em reservar uma quadra esportiva. Suas principais ações são consultar arenas, visualizar quadras disponíveis, criar solicitações de reserva e acompanhar o status da reserva.

### Prestador

O prestador é o administrador da arena esportiva. Suas principais ações são cadastrar arenas, cadastrar quadras, configurar dados das quadras, visualizar reservas e aceitar ou recusar solicitações.

## 4. Funcionalidades implementadas na Sprint 1

Na Sprint 1 foi implementado o backend REST do HubArena, com as operações essenciais do domínio.

As funcionalidades entregues foram:

- verificação de funcionamento da API;
- verificação da conexão com PostgreSQL;
- criação e listagem de usuários;
- consulta de usuário por ID;
- criação e listagem de arenas;
- consulta de arena por ID;
- criação e listagem de quadras;
- consulta de quadra por ID;
- criação de reservas;
- listagem de reservas;
- consulta de reserva por ID;
- aceite de reservas pendentes;
- recusa de reservas pendentes.

No modelo do sistema, uma arena representa o estabelecimento esportivo. Uma quadra, representada pela entidade Court, pertence a uma arena e possui modalidade esportiva, preço por hora, capacidade e disponibilidade.

## 5. Arquitetura implementada

A arquitetura do projeto foi organizada como um repositório geral chamado HubArena, preparado para as quatro sprints da disciplina.

A estrutura principal do repositório é:

- backend: API REST em Flask;
- mobile/cliente: espaço reservado para o aplicativo Flutter do cliente;
- mobile/prestador: espaço reservado para o aplicativo Flutter do prestador;
- docs/sprint1: documentação consolidada da Sprint 1;
- docs/sprint2, docs/sprint3 e docs/sprint4: pastas preparadas para as próximas entregas;
- postman: coleção Postman consolidada.

O backend foi implementado em Flask/Python e organizado em camadas:

- routes;
- controllers;
- services;
- repositories;
- models;
- database;
- config.

Essa separação favorece organização, manutenção e aderência a boas práticas de arquitetura em camadas. A persistência foi realizada com PostgreSQL, executado via Docker Compose, e o acesso ao banco foi feito com SQLAlchemy.

O diagrama de arquitetura foi produzido em PlantUML e representa os componentes principais do sistema: App Cliente, App Prestador, Backend REST, PostgreSQL e RabbitMQ. Na Sprint 1, o RabbitMQ aparece como componente arquitetural planejado para a Sprint 2.

## 6. Endpoints REST implementados

A API REST implementada na Sprint 1 contém os seguintes grupos de endpoints:

| Grupo | Método | Endpoint | Descrição |
|---|---|---|---|
| Health | GET | /health | Verifica se a API está ativa |
| Health | GET | /health/db | Verifica conexão com PostgreSQL |
| Users | POST | /users | Cria cliente ou prestador |
| Users | GET | /users | Lista usuários |
| Users | GET | /users/{id} | Consulta usuário por ID |
| Arenas | POST | /arenas | Cria arena |
| Arenas | GET | /arenas | Lista arenas |
| Arenas | GET | /arenas/{id} | Consulta arena por ID |
| Courts | POST | /courts | Cria quadra |
| Courts | GET | /courts | Lista quadras |
| Courts | GET | /courts/{id} | Consulta quadra por ID |
| Reservations | POST | /reservations | Cria reserva |
| Reservations | GET | /reservations | Lista reservas |
| Reservations | GET | /reservations/{id} | Consulta reserva por ID |
| Reservations | PUT | /reservations/{id}/accept | Aceita reserva pendente |
| Reservations | PUT | /reservations/{id}/reject | Recusa reserva pendente |

Esses endpoints cobrem o fluxo principal da Sprint 1: criação de prestador, criação de cliente, cadastro de arena, cadastro de quadra, criação de reserva e atualização do status da reserva.

## 7. Tecnologias utilizadas

As tecnologias utilizadas na Sprint 1 foram:

- Python 3.12;
- Flask;
- Flask-SQLAlchemy;
- Flask-CORS;
- PostgreSQL;
- Docker Compose;
- pg8000;
- PlantUML;
- Postman;
- requests para testes automatizados.

A escolha por Flask permitiu construir uma API REST objetiva e compatível com o escopo da sprint. O PostgreSQL foi escolhido por oferecer persistência relacional robusta e adequada ao crescimento futuro do sistema.

## 8. Artefatos produzidos

Foram produzidos os seguintes artefatos:

- backend REST funcional em Flask;
- banco PostgreSQL configurado via Docker Compose;
- schema documentado;
- diagrama de arquitetura em PlantUML;
- imagem PNG do diagrama de arquitetura;
- coleção Postman com endpoints da Sprint 1;
- README específico da coleção Postman;
- relatório de testes automatizados;
- README geral do projeto;
- README do backend;
- documento de proposta em Markdown e PDF.

## 9. Preparação para as próximas sprints

A Sprint 1 preparou a base para evolução do HubArena. Na Sprint 2, será implementada a integração com RabbitMQ, com publicação e consumo de eventos como:

- reservation_created;
- reservation_accepted;
- reservation_rejected.

Na Sprint 3 será desenvolvido o aplicativo Flutter do cliente. Na Sprint 4 será desenvolvido o aplicativo Flutter do prestador e o fluxo completo de ponta a ponta.

## 10. Conclusão

O HubArena apresenta um domínio claro, viável e alinhado aos requisitos da disciplina. A Sprint 1 estabelece a base técnica do sistema distribuído por meio de backend REST funcional, persistência em PostgreSQL, documentação arquitetural, coleção Postman e testes automatizados.

A solução está preparada para evoluir nas próximas sprints com comunicação assíncrona via RabbitMQ e desenvolvimento dos aplicativos móveis em Flutter.
