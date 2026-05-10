# HubArena - Backend REST - Sprint 1

## 1. Descrição do Projeto

O HubArena é uma plataforma distribuída para reserva de quadras esportivas. O sistema conecta clientes interessados em reservar quadras com prestadores responsáveis por arenas esportivas.

Na Sprint 1, foi implementado o backend REST com persistência em PostgreSQL, cobrindo o fluxo básico de cadastro de usuários, criação de arenas, criação de quadras, solicitação de reserva e atualização de status.

## 2. Perfis de Usuário

### Cliente

Usuário que busca arenas, consulta quadras disponíveis e solicita reservas.

### Prestador

Administrador da arena esportiva, responsável por cadastrar arenas, gerenciar quadras e aceitar ou recusar reservas.

## 3. Tecnologias Utilizadas

- Python 3.12
- Flask
- Flask-SQLAlchemy
- Flask-CORS
- PostgreSQL
- Docker Compose
- pg8000
- requests
- PlantUML
- Postman

## 4. Arquitetura do Backend

O backend foi organizado em camadas, seguindo boas práticas de separação de responsabilidades.

| Camada | Responsabilidade |
|---|---|
| routes | Define as rotas REST |
| controllers | Recebe requisições HTTP e retorna respostas JSON |
| services | Concentra regras de negócio |
| repositories | Acessa o banco de dados |
| models | Define as entidades persistidas |
| database | Configura o SQLAlchemy |
| config | Centraliza configurações da aplicação |

## 5. Componentes Arquiteturais

| Componente | Tecnologia | Função |
|---|---|---|
| App Cliente | Flutter/Dart | Permitir que o cliente crie e acompanhe reservas |
| App Prestador | Flutter/Dart | Permitir que o prestador gerencie solicitações |
| Backend REST | Flask/Python | Expor endpoints e regras de negócio |
| Banco de Dados | PostgreSQL | Persistir dados do domínio |
| MOM | RabbitMQ | Comunicação assíncrona prevista para a Sprint 2 |

## 6. Diagrama de Arquitetura

> **Artefatos do diagrama**
>
> O projeto utiliza **PlantUML** para representar a arquitetura do backend e os principais componentes do sistema.

O arquivo-fonte do diagrama está localizado em:

```text
docs/architecture.puml
```

A imagem gerada a partir do PlantUML está localizada em:

```text
docs/diagrams/hubarena_architecture.png
```

## 7. Banco de Dados

> **Banco utilizado**
>
> A Sprint 1 utiliza **PostgreSQL** como banco de dados relacional, executado localmente por meio do Docker Compose.

Configuração local via Docker Compose:

| Item | Valor |
|---|---|
| Database | hubarena_db |
| User | hubarena_user |
| Password | hubarena_pass |
| Porta | 5432 |

A documentação do schema está localizada em:

```text
docs/schema.md
```

## 8. Como Executar

> **Passo a passo de execução**
>
> Os comandos abaixo devem ser executados dentro da pasta `backend/`.

### 8.1 Subir o PostgreSQL

```bash
docker compose up -d
```

> Esse comando inicializa o container PostgreSQL usado pela aplicação.

### 8.2 Ativar o ambiente virtual no Git Bash

```bash
source venv/bin/activate
```

> Após ativar o ambiente, o terminal deve exibir algo semelhante a `(venv)`.

### 8.3 Instalar dependências

```bash
pip install -r requirements.txt
```

> Esse comando instala as bibliotecas Python necessárias para executar o backend.

### 8.4 Criar as tabelas

```bash
python init_db.py
```

> Esse comando cria as tabelas no PostgreSQL a partir dos modelos definidos no SQLAlchemy.

### 8.5 Rodar o backend

```bash
python run.py
```

A API ficará disponível em:

```text
http://127.0.0.1:5000
```

## 9. Endpoints Implementados

### Health

| Método | Endpoint | Descrição |
|---|---|---|
| GET | /health | Verifica se a API está ativa |
| GET | /health/db | Verifica conexão com PostgreSQL |

### Users

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /users | Cria cliente ou prestador |
| GET | /users | Lista usuários |
| GET | /users/{id} | Consulta usuário por ID |

### Arenas

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /arenas | Cria uma arena |
| GET | /arenas | Lista arenas |
| GET | /arenas/{id} | Consulta arena por ID |

### Courts

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /courts | Cria uma quadra |
| GET | /courts | Lista quadras |
| GET | /courts/{id} | Consulta quadra por ID |

### Reservations

| Método | Endpoint | Descrição |
|---|---|---|
| POST | /reservations | Cria uma solicitação de reserva |
| GET | /reservations | Lista reservas |
| GET | /reservations/{id} | Consulta reserva por ID |
| PUT | /reservations/{id}/accept | Aceita reserva pendente |
| PUT | /reservations/{id}/reject | Recusa reserva pendente |

## 10. Fluxo Principal Validado

1. Criar usuário prestador.
2. Criar usuário cliente.
3. Criar arena vinculada ao prestador.
4. Criar quadra vinculada à arena.
5. Criar reserva vinculada ao cliente e à quadra.
6. Atualizar status da reserva para ACCEPTED ou REJECTED.

## 11. Coleção Postman

> **Testes dos endpoints**
>
> A coleção Postman contém os endpoints REST implementados na Sprint 1, com exemplos de requisições.

A coleção de testes da Sprint 1 está localizada em:

```text
postman/HubArena_Sprint1.postman_collection.json
```

## 12. Eventos Previstos para Sprint 2

| Evento | Descrição |
|---|---|
| reservation_created | Publicado quando uma reserva for criada |
| reservation_accepted | Publicado quando uma reserva for aceita |
| reservation_rejected | Publicado quando uma reserva for recusada |

## 13. Estrutura de Pastas

```text
backend/
├── app/
│   ├── config/
│   ├── controllers/
│   ├── database/
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

## 14. Observação

A Sprint 1 implementa o backend REST e prepara a base arquitetural para integração assíncrona com RabbitMQ na Sprint 2.
