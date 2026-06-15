# Relatório de Integração com MOM — Sprint 2

## 1. Introdução

A Sprint 2 do HubArena teve como objetivo integrar o backend Flask a um Middleware Orientado a Mensagens, permitindo comunicação assíncrona entre componentes do sistema. Para isso, foi utilizado o RabbitMQ como broker de mensagens e a biblioteca Python pika para comunicação com o protocolo AMQP.

A implementação foi feita preservando a estrutura original do projeto. A camada de mensageria foi adicionada em backend/app/messaging, enquanto a documentação da Sprint 2 foi organizada em docs/sprint2, seguindo o mesmo padrão já usado na Sprint 1.

---

## 2. Escolha da ferramenta

O MOM escolhido foi o RabbitMQ, executado por meio do Docker Compose com a imagem rabbitmq:3-management.

A escolha do RabbitMQ se justifica pelos seguintes motivos:

- permite comunicação assíncrona entre produtor e consumidor;
- oferece filas duráveis;
- permite publicação de mensagens persistentes;
- utiliza confirmação de processamento por ACK;
- possui painel web de gerenciamento;
- facilita a visualização das filas, mensagens e consumidores durante a demonstração.

O painel de gerenciamento pode ser acessado em:

http://localhost:15672

Credenciais utilizadas:

usuário: hubarena

senha: hubarena_pass

---

## 3. Padrão de comunicação utilizado

O padrão adotado foi uma fila de eventos.

O backend Flask atua como produtor de eventos e publica mensagens na fila:

hubarena.reservations.events

O consumidor ReservationConsumer atua como consumidor assíncrono e fica escutando essa fila. Quando uma mensagem chega, ele identifica o tipo do evento e executa a ação correspondente.

O fluxo geral da comunicação é:

Postman -> Backend Flask -> RabbitMQ -> ReservationConsumer

Não existe chamada REST direta entre o backend e o consumidor. O consumidor não possui endpoint HTTP. Ele recebe mensagens exclusivamente pelo RabbitMQ.

---

## 4. Eventos implementados

Foram implementados dois eventos principais do fluxo de reservas:

reservation.created

reservation.status_changed

O evento reservation.created é publicado quando uma nova reserva é criada com sucesso pelo endpoint POST /reservations.

O evento reservation.status_changed é publicado quando uma reserva pendente é aceita ou recusada pelos endpoints PUT /reservations/{id}/accept e PUT /reservations/{id}/reject.

Esses dois eventos representam momentos distintos do fluxo de negócio, conforme exigido para a Sprint 2.

---

## 5. Produtor de eventos

O produtor de eventos foi implementado no arquivo:

backend/app/messaging/event_publisher.py

Esse componente recebe o nome do evento e o payload, monta um envelope JSON padronizado e publica a mensagem na fila RabbitMQ.

O produtor é chamado a partir do serviço de reservas:

backend/app/services/reservation_service.py

A publicação foi adicionada na camada de serviço para manter a organização original do projeto. Assim, controllers, routes, models e repositories foram preservados.

---

## 6. Consumidor assíncrono

O consumidor assíncrono foi implementado no arquivo:

backend/app/messaging/reservation_consumer.py

Ele é executado separadamente do backend Flask com o comando:

python -m app.messaging.reservation_consumer

O consumidor escuta a fila hubarena.reservations.events, processa os eventos recebidos e confirma o processamento com ACK.

Para o evento reservation.created, o consumidor simula a notificação ao prestador sobre uma nova reserva.

Para o evento reservation.status_changed, o consumidor simula a notificação ao cliente sobre a alteração do status da reserva.

---

## 7. Demonstração de assincronicidade

A assincronicidade é demonstrada executando o backend Flask e o consumidor em terminais separados.

O teste ocorre da seguinte forma:

1. O avaliador envia uma requisição pelo Postman para criar ou alterar uma reserva.
2. O backend Flask processa a requisição REST normalmente.
3. O backend publica um evento no RabbitMQ.
4. O consumidor recebe e processa a mensagem pela fila.
5. O consumidor confirma o processamento com ACK.

Essa separação comprova que o consumidor não é chamado por REST. Ele processa eventos publicados no RabbitMQ de forma assíncrona.

---

## 8. Evidências de funcionamento

As evidências recomendadas para a avaliação são:

- Docker Compose exibindo PostgreSQL e RabbitMQ em execução;
- painel RabbitMQ aberto em http://localhost:15672;
- fila hubarena.reservations.events criada;
- Postman retornando 200 no endpoint /health/rabbitmq;
- Postman retornando 201 na criação de uma reserva;
- terminal Flask exibindo a publicação do evento reservation.created;
- terminal consumidor exibindo o recebimento do evento reservation.created;
- Postman retornando 200 ao aceitar ou recusar uma reserva;
- terminal consumidor exibindo o recebimento do evento reservation.status_changed.

---

## 9. Desafios encontrados

Durante a implementação, foram encontrados alguns desafios técnicos:

1. Configuração do Docker Desktop no Windows para executar PostgreSQL e RabbitMQ.
2. Ajuste do ambiente virtual Python no Git Bash, pois havia mais de uma instalação de Python disponível.
3. Recuperação do volume antigo do PostgreSQL usado na Sprint 1, para manter os registros já cadastrados anteriormente.
4. Organização da documentação seguindo a estrutura original do projeto.
5. Implementação da mensageria sem alterar a arquitetura principal de controllers, services, repositories e models.

Esses desafios foram resolvidos mantendo a estrutura já existente do HubArena.

---

## 10. Conclusão

A Sprint 2 integrou o HubArena ao RabbitMQ e implementou comunicação assíncrona orientada a eventos. O backend passou a publicar eventos em dois momentos do fluxo de reservas, e um consumidor independente passou a processar essas mensagens sem chamada REST direta.

A implementação atende aos critérios da Sprint 2: MOM operacional, produtor e consumidor implementados, documentação dos eventos, demonstração de assincronicidade e relatório de integração.