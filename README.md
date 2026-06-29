# HubArena - Backend REST e Integração das Sprints 1 a 4

## 1. Descrição do Projeto

O **HubArena** é uma plataforma distribuída para reserva e gestão de quadras esportivas. O sistema conecta clientes interessados em reservar espaços esportivos com prestadores responsáveis por arenas, quadras e horários disponíveis.

O projeto foi desenvolvido progressivamente ao longo de quatro sprints:

- **Sprint 1:** backend REST com persistência em PostgreSQL.
- **Sprint 2:** integração assíncrona com RabbitMQ.
- **Sprint 3:** aplicativo Flutter para o cliente e integração REST.
- **Sprint 4:** aplicativo do prestador, integração final, notificações, gerenciamento de arenas/quadras e fluxo completo ponta a ponta.

---

## 2. Perfis de Usuário

### Cliente

Usuário consumidor da plataforma. Pode pesquisar arenas, visualizar quadras, criar reservas, acompanhar atualizações, cancelar reservas pendentes, consultar histórico e gerenciar seu perfil.

### Prestador

Usuário ou empresa responsável por arenas esportivas. Pode cadastrar arenas, cadastrar quadras, aceitar ou recusar solicitações, finalizar reservas, acompanhar notificações e gerenciar seu perfil.

---

## 3. Tecnologias Utilizadas

| Categoria | Tecnologias |
|---|---|
| Backend | Python, Flask, Flask-SQLAlchemy, Flask-CORS |
| Banco de dados | PostgreSQL |
| Mensageria | RabbitMQ |
| Mobile | Flutter, Dart |
| Ambiente | Docker Compose, Git Bash, Android Emulator |
| Testes | Postman, flutter analyze, flutter test |
| Documentação | Markdown, PlantUML |

---

## 4. Arquitetura Geral

O sistema foi organizado em componentes independentes:

```text
Flutter App Unificado
Cliente / Prestador
        |
        | REST HTTP
        v
Backend Flask
Routes -> Controllers -> Services -> Repositories -> Models
        |
        | SQLAlchemy
        v
PostgreSQL
        |
        | Eventos
        v
RabbitMQ
Consumer de Reservas
```

---

## 5. Arquitetura do Backend

O backend foi organizado em camadas, seguindo separação de responsabilidades.

| Camada | Responsabilidade |
|---|---|
| routes | Define as rotas REST |
| controllers | Recebe requisições HTTP e retorna respostas JSON |
| services | Concentra regras de negócio |
| repositories | Acessa o banco de dados |
| models | Define as entidades persistidas |
| database | Configura o SQLAlchemy |
| config | Centraliza configurações da aplicação |
| messaging | Publica e consome eventos RabbitMQ |

---

## 6. Componentes Arquiteturais

| Componente | Tecnologia | Função |
|---|---|---|
| App Flutter Unificado | Flutter/Dart | Interface cliente e prestador |
| Backend REST | Flask/Python | Expor endpoints e regras de negócio |
| Banco de Dados | PostgreSQL | Persistir dados do domínio |
| MOM | RabbitMQ | Comunicação assíncrona por eventos |
| Postman | Postman | Testes e validação dos endpoints |

---

## 7. Sprint 1 - Backend REST

### 7.1 Objetivo

A Sprint 1 implementou a base funcional do HubArena, com backend REST, persistência em PostgreSQL e endpoints para os principais recursos do domínio.

### 7.2 Funcionalidades Implementadas

- Cadastro de usuários.
- Listagem e consulta de usuários.
- Cadastro e consulta de arenas.
- Cadastro e consulta de quadras.
- Criação de reservas.
- Aceite e recusa de reservas.
- Organização do backend em camadas.
- Docker Compose para PostgreSQL.
- Coleção Postman para validação.

### 7.3 Fluxo Validado

1. Criar usuário prestador.
2. Criar usuário cliente.
3. Criar arena vinculada ao prestador.
4. Criar quadra vinculada à arena.
5. Criar reserva vinculada ao cliente e à quadra.
6. Atualizar status da reserva para `ACCEPTED` ou `REJECTED`.

---

## 8. Sprint 2 - RabbitMQ e Comunicação Assíncrona

### 8.1 Objetivo

A Sprint 2 adicionou comunicação assíncrona ao sistema utilizando RabbitMQ como middleware orientado a mensagens.

### 8.2 Componentes Adicionados

| Componente | Função |
|---|---|
| rabbitmq_client.py | Gerencia conexão com RabbitMQ |
| event_publisher.py | Publica eventos no broker |
| reservation_consumer.py | Consome eventos relacionados a reservas |

### 8.3 Eventos

| Evento | Descrição |
|---|---|
| reservation.created | Publicado quando uma reserva é criada |
| reservation.status_changed | Publicado quando uma reserva é aceita ou recusada |
| reservation.cancelled | Publicado quando uma reserva é cancelada |
| reservation.finished | Publicado quando uma reserva é finalizada |

### 8.4 Fluxo Assíncrono

```text
Cliente cria reserva
        |
Backend salva no PostgreSQL
        |
Backend publica evento reservation.created
        |
RabbitMQ recebe mensagem
        |
Consumer processa evento
        |
Prestador visualiza solicitação
```

### 8.5 Painel RabbitMQ

```text
http://localhost:15672
Usuário: guest
Senha: guest
```

---

## 9. Sprint 3 - Aplicativo Flutter do Cliente

### 9.1 Objetivo

A Sprint 3 iniciou a implementação mobile com Flutter, integrando o aplicativo ao backend REST.

### 9.2 Funcionalidades do Cliente

- Tela inicial.
- Login.
- Cadastro.
- Visualização de arenas.
- Visualização de quadras.
- Criação de reservas.
- Consulta de reservas do cliente.
- Atualização por polling.
- Perfil do usuário.
- Notificações visuais.

### 9.3 Integração REST

O Flutter passou a consumir endpoints do backend para:

- usuários;
- arenas;
- quadras;
- reservas;
- status de reservas.

---

## 10. Sprint 4 - App Prestador e Integração Final

### 10.1 Objetivo

A Sprint 4 completou o fluxo do sistema com app do prestador e integração final ponta a ponta entre cliente, backend, RabbitMQ e prestador.

### 10.2 Funcionalidades do Prestador

- Login.
- Cadastro.
- Perfil como `EMPRESA` ou `USUARIO`.
- Dashboard.
- Solicitações pendentes.
- Reservas em andamento.
- Histórico.
- Avisos/notificações.
- Cadastro de arenas.
- Edição de arenas.
- Exclusão de arenas.
- Cadastro de quadras.
- Edição de quadras.
- Exclusão de quadras.
- Aceite e recusa de reservas.
- Finalização de reservas.

### 10.3 Funcionalidades do Cliente na Sprint 4

- Pesquisa por esporte, arena ou quadra.
- Filtros por esporte com emojis.
- Visualização de arenas com imagem.
- Visualização de quadras com imagem.
- Criação de reservas.
- Cancelamento de reservas pendentes.
- Avisos e notificações.
- Limpeza de notificações.
- Perfil editável.

### 10.4 Imagens Automáticas

O backend gera automaticamente imagens padrão para arenas e quadras quando o usuário não informa uma URL manual.

Exemplo:

```json
{
  "name": "Arena Futebol Pampulha",
  "sport": "Futebol",
  "imageUrl": null
}
```

Resultado esperado:

```json
{
  "name": "Arena Futebol Pampulha",
  "sport": "Futebol",
  "imageUrl": "https://images.pexels.com/..."
}
```

O usuário pode editar posteriormente e substituir a imagem por outra URL.

---

## 11. Banco de Dados

### 11.1 Configuração Local

| Item | Valor |
|---|---|
| Database | hubarena_db |
| User | hubarena_user |
| Password | hubarena_pass |
| Porta | 5432 |

### 11.2 Tabelas Principais

| Tabela | Descrição |
|---|---|
| users | Clientes e prestadores |
| arenas | Arenas esportivas |
| courts | Quadras vinculadas às arenas |
| reservations | Solicitações e reservas |

### 11.3 Status de Reserva

| Status | Descrição |
|---|---|
| PENDING | Reserva criada e aguardando resposta |
| ACCEPTED | Reserva aceita pelo prestador |
| REJECTED | Reserva recusada pelo prestador |
| CANCELLED | Reserva cancelada pelo cliente |
| FINISHED | Reserva finalizada pelo prestador |

---

## 12. Como Executar o Projeto

Os comandos abaixo devem ser executados considerando a estrutura local do projeto.

### 12.1 Subir PostgreSQL e RabbitMQ

Dentro da pasta `backend/`:

```bash
docker compose up -d
```

Ou, caso os containers já existam:

```bash
docker start hubarena-postgres hubarena-rabbitmq
```

### 12.2 Ativar Ambiente Virtual

No Git Bash:

```bash
source .venv/Scripts/activate
```

### 12.3 Instalar Dependências

```bash
pip install -r requirements.txt
```

### 12.4 Criar ou Atualizar Tabelas

```bash
python init_db.py
```

### 12.5 Rodar Backend

```bash
python run.py
```

API disponível em:

```text
http://127.0.0.1:5000
```

### 12.6 Rodar Consumer RabbitMQ

Em outro terminal:

```bash
cd backend
source .venv/Scripts/activate
python -m app.messaging.reservation_consumer
```

### 12.7 Rodar App Flutter

```bash
cd mobile/hubarena_app

flutter run -d emulator-5554 --dart-define=API_BASE_URL=http://10.0.2.2:5000 --dart-define=CLIENT_ID=2 --dart-define=PROVIDER_ID=1
```

---

## 13. Credenciais de Teste

### Cliente

```text
cliente@hubarena.com
123456
```

### Prestador

```text
prestador@hubarena.com
123456
```

---

## 14. Endpoints Implementados

### Health

| Método | Endpoint | Descrição |
|---|---|---|
| GET | /health/api | Verifica se a API está ativa |
| GET | /health/db | Verifica conexão com PostgreSQL |
| GET | /health/rabbitmq | Verifica conexão com RabbitMQ |

### Users

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /users | Cria cliente ou prestador |
| GET | /users | Lista usuários |
| GET | /users/{id} | Consulta usuário por ID |
| POST | /users/login | Realiza login |
| PUT | /users/{id} | Atualiza perfil |
| PUT | /users/{id}/password | Altera senha |
| PUT | /users/{id}/profile-photo | Atualiza foto de perfil |
| DELETE | /users/{id}/profile-photo | Remove foto de perfil |

### Arenas

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /arenas | Cria arena |
| GET | /arenas | Lista arenas |
| GET | /arenas/{id} | Consulta arena |
| PUT | /arenas/{id} | Atualiza arena |
| DELETE | /arenas/{id} | Exclui arena |

### Courts

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /courts | Cria quadra |
| GET | /courts | Lista quadras |
| GET | /courts/{id} | Consulta quadra |
| PUT | /courts/{id} | Atualiza quadra |
| DELETE | /courts/{id} | Exclui quadra |

### Reservations

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /reservations | Cria reserva |
| GET | /reservations | Lista reservas |
| GET | /reservations/{id} | Consulta reserva |
| GET | /reservations/client/{client_id} | Lista reservas do cliente |
| GET | /reservations/provider/{provider_id} | Lista reservas do prestador |
| GET | /reservations/status/{status} | Lista reservas por status |
| PUT | /reservations/{id}/accept | Aceita reserva |
| PUT | /reservations/{id}/reject | Recusa reserva |
| PUT | /reservations/{id}/cancel | Cancela reserva |
| PUT | /reservations/{id}/finish | Finaliza reserva |

---

## 15. Coleção Postman

A coleção Postman deve conter os seguintes grupos:

```text
Health
Users
Arenas
Courts
Reservations
RabbitMQ
Sprint4
```

Coleções utilizadas:

```text
postman/HubArena_Sprint1.postman_collection.json
postman/HubArena_Sprint2.postman_collection.json
postman/HubArena_Sprint4.postman_collection.json
```

---

## 16. Fluxo Completo Validado

```text
Prestador faz login
        |
Cria arena sem imageUrl
        |
Backend gera imagem automática
        |
Cria quadra sem imageUrl
        |
Backend gera imagem automática
        |
Cliente faz login
        |
Pesquisa esporte/arena
        |
Abre arena
        |
Escolhe quadra
        |
Cria reserva
        |
Backend publica evento RabbitMQ
        |
Prestador visualiza solicitação
        |
Prestador aceita
        |
Cliente visualiza atualização
        |
Prestador finaliza reserva
```

---

## 17. Testes

### Backend

```bash
python run.py
```

Validar no Postman:

```text
GET /health/api
GET /health/db
GET /health/rabbitmq
```

### RabbitMQ

```bash
python -m app.messaging.reservation_consumer
```

Criar reserva no Postman e verificar evento no terminal do consumer.

### Flutter

```bash
dart format lib test
flutter analyze
flutter test
```

### Teste Manual no App

1. Entrar como prestador.
2. Criar arena.
3. Criar quadra.
4. Entrar como cliente.
5. Pesquisar arena.
6. Criar reserva.
7. Voltar ao prestador.
8. Aceitar reserva.
9. Voltar ao cliente.
10. Verificar atualização.

---

## 18. Estrutura de Pastas do Backend

```text
backend/
├── app/
│   ├── config/
│   ├── controllers/
│   ├── database/
│   ├── messaging/
│   ├── models/
│   ├── repositories/
│   ├── routes/
│   └── services/
├── docs/
├── postman/
├── scripts/
├── docker-compose.yml
├── init_db.py
├── run.py
├── requirements.txt
└── README.md
```

---

## 19. Evidências Recomendadas para Apresentação

- Backend Flask rodando.
- Consumer RabbitMQ rodando.
- Painel RabbitMQ aberto.
- App Flutter executando.
- Prestador criando arena.
- Prestador criando quadra.
- Cliente criando reserva.
- Evento RabbitMQ sendo exibido.
- Prestador aceitando reserva.
- Cliente visualizando atualização.
- Filtros e pesquisa funcionando.
- Notificações funcionando.

---

## 20. Roadmap

Melhorias futuras:

- Autenticação JWT.
- Upload real de imagens.
- Integração com API externa de imagens.
- WebSocket em vez de polling.
- Push notifications.
- Avaliações de arenas.
- Pagamentos online.
- Geolocalização.
- Mapa de arenas próximas.
- Deploy em nuvem.

---

## 21. Observação Final

A documentação original da Sprint 1 foi reorganizada e ampliada para representar a evolução completa do HubArena nas quatro sprints. O projeto passou de uma API REST básica para um sistema distribuído com backend, banco relacional, mensageria assíncrona e aplicativo Flutter integrado.