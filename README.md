# HubArena

> **Projeto:** HubArena  
> **Disciplina:** Laboratório de Desenvolvimento de Aplicações Móveis e Distribuídas  
> **Organização:** Projeto estruturado para quatro sprints  
---

## 1. Descrição do Projeto

O **HubArena** é uma plataforma distribuída para reserva de quadras esportivas, conectando clientes interessados em reservar espaços esportivos com prestadores responsáveis por arenas, quadras e horários disponíveis.

O projeto foi organizado para evoluir progressivamente ao longo das quatro sprints da disciplina, contemplando backend REST, banco de dados, middleware orientado a mensagens e aplicativos móveis em Flutter.

---

## 2. Estrutura do Repositório

> **Organização geral**
>
> A pasta `hubarena/` concentra todo o projeto, separando backend, documentação, coleção Postman e futuras aplicações móveis.

```text
hubarena/
├── backend/
├── mobile/
│   ├── cliente/
│   └── prestador/
├── docs/
│   ├── sprint1/
│   ├── sprint2/
│   ├── sprint3/
│   └── sprint4/
├── postman/
├── README.md
└── .gitignore
```

### 2.1 Descrição das pastas

| Pasta | Descrição |
|---|---|
| `backend/` | Contém o backend REST implementado em Flask |
| `mobile/cliente/` | Espaço reservado para o app Flutter do cliente |
| `mobile/prestador/` | Espaço reservado para o app Flutter do prestador |
| `docs/sprint1/` | Documentação consolidada da Sprint 1 |
| `docs/sprint2/` | Espaço reservado para documentação da integração com MOM |
| `docs/sprint3/` | Espaço reservado para documentação do app cliente |
| `docs/sprint4/` | Espaço reservado para relatório final, screencast e evidências |
| `postman/` | Coleção Postman consolidada dos endpoints da Sprint 1 |

---

## 3. Sprint 1 - Arquitetura e Backend REST

A Sprint 1 implementa:

- proposta de domínio;
- diagrama de arquitetura;
- backend REST em Flask;
- banco PostgreSQL;
- schema documentado;
- coleção Postman;
- testes automatizados dos endpoints.

> **Resumo da Sprint 1**
>
> A primeira sprint estabelece a base técnica do HubArena, com backend funcional, persistência em banco de dados, documentação arquitetural e coleção de testes.

---

## 4. Backend

> **Localização do backend**
>
> O backend REST da aplicação está localizado na pasta:

```text
backend/
```

O backend contém:

- API Flask;
- modelos SQLAlchemy;
- rotas REST;
- controllers;
- services;
- repositories;
- configuração do PostgreSQL;
- scripts de documentação e testes;
- coleção Postman local;
- documentação técnica.

---

## 5. Como Executar o Backend

> **Passo a passo**
>
> Os comandos abaixo devem ser executados a partir da pasta raiz `hubarena/`.

### 5.1 Entrar na pasta do backend

```bash
cd backend
```

---

### 5.2 Subir o PostgreSQL

```bash
docker compose up -d
```

> Esse comando inicia o container PostgreSQL utilizado pelo backend.

---

### 5.3 Ativar o ambiente virtual

No Git Bash:

```bash
source venv/bin/activate
```

> Após a ativação, o terminal deve exibir algo semelhante a `(venv)`.

---

### 5.4 Criar as tabelas no banco

```bash
python init_db.py
```

> Esse comando cria as tabelas do banco de dados com base nos modelos definidos no backend.

---

### 5.5 Rodar o servidor Flask

```bash
python run.py
```

A API ficará disponível em:

```text
http://127.0.0.1:5000
```

---

## 6. Documentação da Sprint 1

> **Documentação consolidada**
>
> Os principais documentos formais da Sprint 1 estão reunidos na pasta:

```text
docs/sprint1/
```

Arquivos principais:

| Arquivo | Descrição |
|---|---|
| `proposta_sprint1.pdf` | Documento de proposta em PDF |
| `proposta_sprint1.md` | Documento de proposta em Markdown |
| `architecture.puml` | Diagrama de arquitetura em PlantUML |
| `hubarena_architecture.png` | Imagem gerada do diagrama de arquitetura |
| `schema.md` | Documentação do schema do banco de dados |
| `api_test_results.md` | Relatório de execução dos testes automatizados |

---

## 7. Coleção Postman

> **Testes dos endpoints**
>
> A coleção Postman da Sprint 1 está localizada em:

```text
postman/HubArena_Sprint1.postman_collection.json
```

Essa coleção contém os endpoints REST implementados na Sprint 1, organizados nos seguintes grupos:

```text
Health
Users
Arenas
Courts
Reservations
```

---

## 8. Próximas Sprints

### Sprint 2

Integração com **RabbitMQ** e implementação de eventos assíncronos.

Eventos previstos:

| Evento | Descrição |
|---|---|
| `reservation_created` | Publicado quando uma reserva for criada |
| `reservation_accepted` | Publicado quando uma reserva for aceita |
| `reservation_rejected` | Publicado quando uma reserva for recusada |

---

### Sprint 3

Desenvolvimento do aplicativo Flutter do cliente.

O app cliente deverá permitir:

- consultar arenas;
- visualizar quadras;
- criar reservas;
- acompanhar atualizações de status.

---

### Sprint 4

Desenvolvimento do aplicativo Flutter do prestador e integração final de ponta a ponta.

O app prestador deverá permitir:

- visualizar reservas pendentes;
- aceitar reservas;
- recusar reservas;
- acompanhar solicitações em andamento.

---

## 9. Caminhos Principais

| Item | Caminho |
|---|---|
| Backend REST | `backend/` |
| README do backend | `backend/README.md` |
| Documentação Sprint 1 | `docs/sprint1/` |
| Proposta em PDF | `docs/sprint1/proposta_sprint1.pdf` |
| Diagrama PlantUML | `docs/sprint1/architecture.puml` |
| Imagem do diagrama | `docs/sprint1/hubarena_architecture.png` |
| Schema do banco | `docs/sprint1/schema.md` |
| Relatório de testes | `docs/sprint1/api_test_results.md` |
| Coleção Postman | `postman/HubArena_Sprint1.postman_collection.json` |

---

## 10. Observação Final

A estrutura do projeto foi planejada para manter as entregas organizadas por sprint, separando código-fonte, documentação, coleção de testes e artefatos futuros dos aplicativos móveis.

A Sprint 1 entrega a base funcional do sistema por meio do backend REST e prepara o HubArena para evoluir nas próximas etapas com comunicação assíncrona, aplicativos móveis e integração completa entre cliente, backend, middleware e prestador.
