# Guia passo a passo de execução e validação — Sprint 2

## Objetivo deste guia

Este documento apresenta um roteiro passo a passo para executar, testar e demonstrar a Sprint 2 do projeto HubArena.

A Sprint 2 integra o backend Flask com um Middleware Orientado a Mensagens usando RabbitMQ. O objetivo é demonstrar comunicação assíncrona orientada a eventos entre o backend e um consumidor independente.

Este guia foi escrito para permitir que o avaliador consiga reproduzir todos os testes da Sprint 2.

---

## 1. Critérios avaliados na Sprint 2

A Sprint 2 vale 20 pontos, distribuídos da seguinte forma:

| Critério | Pontos | Como validar |
|---|---:|---|
| MOM funcionando corretamente | 5 | Subir RabbitMQ, acessar painel e testar /health/rabbitmq |
| Produtor e consumidor de eventos | 6 | Criar reserva e alterar status, observando publicação e consumo |
| Documentação dos eventos | 4 | Ver arquivo docs/sprint2/eventos_mom.md |
| Demonstração de assincronicidade real | 3 | Rodar backend e consumidor em terminais separados |
| Relatório de integração | 2 | Ver arquivo docs/sprint2/relatorio_integracao_mom.md |

---

## 2. Estrutura dos arquivos da Sprint 2

Arquivos principais criados ou alterados:

backend/docker-compose.yml

backend/requirements.txt

backend/app/config/config.py

backend/app/routes/health_routes.py

backend/app/services/reservation_service.py

backend/app/messaging/rabbitmq_client.py

backend/app/messaging/event_publisher.py

backend/app/messaging/reservation_consumer.py

docs/sprint2/README.md

docs/sprint2/eventos_mom.md

docs/sprint2/relatorio_integracao_mom.md

docs/sprint2/guia_execucao_passo_a_passo.md

---

## 3. Pré-requisitos

Antes de executar, é necessário ter instalado:

- Docker Desktop
- Python 3.13 ou versão compatível
- Git Bash
- Postman
- Navegador web

O Docker Desktop precisa estar em execução antes de subir os containers.

---

## 4. Entrar na pasta correta do backend

A partir da raiz do repositório:

cd hubarena/backend

No ambiente local de desenvolvimento, o caminho usado foi:

cd /c/Users/jscas/OneDrive/Desktop/lab05-sistemas-distribuidos-push/hubarena/backend

Verifique se existem os arquivos:

ls

Devem aparecer, entre outros:

app/
docker-compose.yml
requirements.txt
run.py

---

## 5. Subir PostgreSQL e RabbitMQ

Dentro da pasta hubarena/backend, execute:

docker compose up -d

Depois verifique:

docker compose ps

Resultado esperado:

hubarena-postgres    Up

hubarena-rabbitmq    Up

O PostgreSQL usa a porta 5432.

O RabbitMQ usa a porta 5672 para AMQP.

O painel web do RabbitMQ usa a porta 15672.

---

## 6. Acessar o RabbitMQ Management

Abra no navegador:

http://localhost:15672

Credenciais:

usuário: hubarena

senha: hubarena_pass

Depois acesse:

Queues and Streams

A fila esperada é:

hubarena.reservations.events

Observação: se a fila ainda não aparecer, execute primeiro o endpoint /health/rabbitmq pelo Postman. Esse endpoint declara a fila no RabbitMQ.

---

## 7. Criar e ativar ambiente virtual Python

Se a pasta .venv ainda não existir nesta cópia do projeto, crie:

py -3.13 -m venv .venv

Ative o ambiente virtual no Git Bash:

source .venv/Scripts/activate

O terminal deve exibir:

(.venv)

Instale as dependências:

pip install -r requirements.txt

Teste se Flask e Pika estão disponíveis:

python -c "import flask; import pika; print('Flask e Pika OK')"

Resultado esperado:

Flask e Pika OK

---

## 8. Inicializar banco de dados, se necessário

Se for a primeira execução em uma máquina nova, execute:

python init_db.py

Resultado esperado:

Banco de dados inicializado com sucesso.

Tabelas criadas: users, arenas, courts, reservations.

Atenção: esse comando cria as tabelas, mas não necessariamente cria registros de teste.

---

## 9. Rodar o backend Flask

No Terminal 1, dentro da pasta hubarena/backend:

source .venv/Scripts/activate

python run.py

Resultado esperado:

Running on http://127.0.0.1:5000

Mantenha esse terminal aberto.

---

## 10. Rodar o consumidor assíncrono

Abra um segundo terminal na pasta hubarena/backend.

Execute:

source .venv/Scripts/activate

python -m app.messaging.reservation_consumer

Resultado esperado:

[ReservationConsumer] Consumidor iniciado.

[ReservationConsumer] Aguardando eventos na fila: hubarena.reservations.events

Mantenha esse terminal aberto.

Esse consumidor não possui endpoint REST. Ele recebe mensagens exclusivamente pela fila do RabbitMQ.

---

## 11. Criar pasta da Sprint 2 no Postman

No Postman, crie uma pasta na collection do projeto chamada:

Sprint 2 - MOM

Dentro dela, salve os seguintes requests:

GET Health API

GET Health DB

GET Health RabbitMQ

GET Users

GET Courts

GET Reservations

POST Create Reservation

PUT Accept Reservation

PUT Reject Reservation

---

## 12. Testar saúde da API

No Postman:

GET http://127.0.0.1:5000/health

Resposta esperada:

{
  "message": "HubArena API is running",
  "status": "ok"
}

Esse teste comprova que o backend Flask está rodando.

---

## 13. Testar saúde do banco

No Postman:

GET http://127.0.0.1:5000/health/db

Resposta esperada:

{
  "database": "PostgreSQL connected",
  "status": "ok"
}

Esse teste comprova que o backend está conectado ao PostgreSQL.

---

## 14. Testar saúde do RabbitMQ

No Postman:

GET http://127.0.0.1:5000/health/rabbitmq

Resposta esperada:

{
  "queue": "hubarena.reservations.events",
  "rabbitmq": "connected",
  "status": "ok"
}

Esse teste comprova que o backend está conectado ao RabbitMQ e que a fila foi declarada.

Esse item atende ao critério:

MOM funcionando corretamente.

---

## 15. Verificar dados existentes

Antes de criar uma reserva, verifique se existem usuários e quadras.

No Postman:

GET http://127.0.0.1:5000/users

GET http://127.0.0.1:5000/courts

Para criar uma reserva é necessário ter:

- um usuário com role CLIENT;
- uma quadra disponível.

No banco usado no desenvolvimento, os dados válidos eram:

clientId: 2

courtId: 1

Se o avaliador estiver usando um banco novo e vazio, é necessário criar dados mínimos antes de testar reservas.

---

## 16. Criar dados mínimos se o banco estiver vazio

Se GET /users e GET /courts retornarem listas vazias, crie os dados abaixo pelo Postman.

### 16.1 Criar usuário prestador

POST http://127.0.0.1:5000/users

Body:

{
  "name": "Arena Pampulha",
  "email": "prestador@hubarena.com",
  "role": "PROVIDER"
}

Guarde o id retornado. Exemplo:

providerId: 1

---

### 16.2 Criar usuário cliente

POST http://127.0.0.1:5000/users

Body:

{
  "name": "Jose Cliente",
  "email": "cliente@hubarena.com",
  "role": "CLIENT"
}

Guarde o id retornado. Exemplo:

clientId: 2

---

### 16.3 Criar arena

POST http://127.0.0.1:5000/arenas

Body:

{
  "name": "HubArena Pampulha",
  "address": "Avenida Antonio Carlos, Belo Horizonte - MG",
  "description": "Arena esportiva com quadras de futebol society e futsal.",
  "providerId": 1
}

Use no providerId o id do usuário PROVIDER criado anteriormente.

Guarde o id retornado. Exemplo:

arenaId: 1

---

### 16.4 Criar quadra

POST http://127.0.0.1:5000/courts

Body:

{
  "arenaId": 1,
  "sport": "Futebol Society",
  "capacity": 10,
  "priceHour": 120.0,
  "available": true
}

Use no arenaId o id da arena criada anteriormente.

Guarde o id retornado. Exemplo:

courtId: 1

---

## 17. Testar o evento reservation.created

Com backend e consumidor rodando, envie pelo Postman:

POST http://127.0.0.1:5000/reservations

Body:

{
  "clientId": 2,
  "courtId": 1,
  "date": "2026-06-20",
  "startTime": "10:00",
  "endTime": "11:00"
}

Atenção: se houver conflito de horário, altere a data ou o horário.

Resposta esperada:

HTTP 201 Created

Guarde o id da reserva criada.

No terminal do Flask deve aparecer:

[EventPublisher] Evento publicado: reservation.created

No terminal do consumidor deve aparecer:

[ReservationConsumer] Evento recebido: reservation.created

[ReservationConsumer] Nova reserva recebida.

[ReservationConsumer] Mensagem processada e confirmada com ACK.

Esse teste comprova que o backend publicou o evento e que o consumidor recebeu a mensagem via RabbitMQ.

Esse item atende aos critérios:

Produtor e consumidor de eventos.

Demonstração de assincronicidade real.

---

## 18. Testar o evento reservation.status_changed

Use o id da reserva criada na etapa anterior.

Exemplo:

PUT http://127.0.0.1:5000/reservations/5/accept

Ou, para recusar:

PUT http://127.0.0.1:5000/reservations/5/reject

Resposta esperada:

HTTP 200 OK

No terminal do Flask deve aparecer:

[EventPublisher] Evento publicado: reservation.status_changed

No terminal do consumidor deve aparecer:

[ReservationConsumer] Evento recebido: reservation.status_changed

[ReservationConsumer] Alteração de status recebida.

[ReservationConsumer] Mensagem processada e confirmada com ACK.

Esse teste comprova o segundo momento de publicação de evento no fluxo de negócio.

---

## 19. Como comprovar a comunicação assíncrona

A comunicação assíncrona é comprovada porque:

1. O Postman chama apenas o backend REST.
2. O backend publica a mensagem no RabbitMQ.
3. O consumidor está em outro processo.
4. O consumidor não possui endpoint HTTP.
5. O consumidor recebe a mensagem pela fila hubarena.reservations.events.
6. O processamento é confirmado com ACK.

Fluxo:

Postman -> Backend Flask -> RabbitMQ -> ReservationConsumer

Não existe chamada REST direta entre backend e consumidor.

---

## 20. Evidências recomendadas para a entrega

Para demonstrar a Sprint 2, recomenda-se apresentar prints ou vídeo curto com:

1. docker compose ps mostrando PostgreSQL e RabbitMQ em execução.
2. RabbitMQ Management aberto em http://localhost:15672.
3. Fila hubarena.reservations.events criada.
4. Postman retornando 200 em /health/rabbitmq.
5. Postman criando uma reserva com HTTP 201.
6. Terminal Flask exibindo reservation.created.
7. Terminal consumidor exibindo reservation.created.
8. Postman aceitando ou recusando reserva com HTTP 200.
9. Terminal Flask exibindo reservation.status_changed.
10. Terminal consumidor exibindo reservation.status_changed.
11. Arquivo docs/sprint2/eventos_mom.md aberto.
12. Arquivo docs/sprint2/relatorio_integracao_mom.md aberto.

---

## 21. Erros comuns e correções

### Erro: connect ECONNREFUSED 127.0.0.1:5000

Causa:

O backend Flask não está rodando.

Correção:

python run.py

---

### Erro: No module named flask

Causa:

Ambiente virtual não ativado ou dependências não instaladas.

Correção:

source .venv/Scripts/activate

pip install -r requirements.txt

---

### Erro: Cliente não encontrado

Causa:

O clientId usado na reserva não existe.

Correção:

Verificar usuários:

GET /users

Usar um id com role CLIENT.

---

### Erro: Quadra não encontrada

Causa:

O courtId usado na reserva não existe.

Correção:

Verificar quadras:

GET /courts

Usar uma quadra existente.

---

### Erro: Somente reservas pendentes podem ser aceitas

Causa:

A reserva já foi aceita ou recusada.

Correção:

Criar uma nova reserva ou usar uma reserva com status PENDING.

---

### Erro: RabbitMQ unavailable

Causa:

RabbitMQ não está rodando ou a URL está incorreta.

Correção:

docker compose up -d

docker compose ps

Verificar se hubarena-rabbitmq está Up.

---

## 22. Checklist final para o avaliador

Antes de concluir a avaliação, verificar:

[ ] RabbitMQ está rodando.

[ ] Endpoint /health/rabbitmq retorna 200.

[ ] Fila hubarena.reservations.events existe.

[ ] Backend publica reservation.created.

[ ] Consumidor recebe reservation.created.

[ ] Backend publica reservation.status_changed.

[ ] Consumidor recebe reservation.status_changed.

[ ] Documentação dos eventos existe.

[ ] Relatório de integração existe.

[ ] Comunicação assíncrona foi demonstrada sem chamada REST direta ao consumidor.

---

## 23. Arquivos de documentação da Sprint 2

Documentação geral:

docs/sprint2/README.md

Documentação dos eventos:

docs/sprint2/eventos_mom.md

Relatório de integração:

docs/sprint2/relatorio_integracao_mom.md

Guia passo a passo de execução:

docs/sprint2/guia_execucao_passo_a_passo.md
