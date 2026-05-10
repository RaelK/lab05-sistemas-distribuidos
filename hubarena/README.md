# HubArena

O HubArena é uma plataforma distribuída para reserva de quadras esportivas, conectando clientes e prestadores responsáveis por arenas esportivas.

## Estrutura do Repositório

hubarena/
- backend/
- mobile/
  - cliente/
  - prestador/
- docs/
  - sprint1/
  - sprint2/
  - sprint3/
  - sprint4/
- postman/
- README.md
- .gitignore

## Sprint 1 - Arquitetura e Backend REST

A Sprint 1 implementa:

- proposta de domínio;
- diagrama de arquitetura;
- backend REST em Flask;
- banco PostgreSQL;
- schema documentado;
- coleção Postman;
- testes automatizados dos endpoints.

## Backend

O backend está localizado em:

backend/

Para executar:

1. Entrar na pasta do backend:

cd backend

2. Subir o PostgreSQL:

docker compose up -d

3. Ativar o ambiente virtual:

source venv/bin/activate

4. Criar as tabelas:

python init_db.py

5. Rodar o servidor Flask:

python run.py

A API ficará disponível em:

http://127.0.0.1:5000

## Documentação da Sprint 1

A documentação consolidada da Sprint 1 está em:

docs/sprint1/

Arquivos principais:

- proposta_sprint1.pdf
- architecture.puml
- hubarena_architecture.png
- schema.md
- api_test_results.md

## Coleção Postman

A coleção Postman está em:

postman/HubArena_Sprint1.postman_collection.json

## Próximas Sprints

### Sprint 2

Integração com RabbitMQ e implementação de eventos assíncronos.

### Sprint 3

Aplicativo Flutter do cliente.

### Sprint 4

Aplicativo Flutter do prestador e integração final de ponta a ponta.
