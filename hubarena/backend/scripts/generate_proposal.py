from pathlib import Path

sections = []

sections.append("""# Proposta de Domínio - HubArena

## 1. Domínio Escolhido

O HubArena é uma plataforma distribuída voltada para reserva de quadras esportivas. O sistema permite que clientes encontrem arenas, consultem quadras disponíveis e solicitem reservas. Ao mesmo tempo, permite que prestadores cadastrem arenas, gerenciem quadras e aceitem ou recusem solicitações de reserva.

O domínio escolhido se enquadra no modelo cliente/prestador, pois existe uma separação clara entre o usuário que consome o serviço e o usuário responsável por ofertar e gerenciar o serviço.
""")

sections.append("""## 2. Justificativa

A reserva de quadras esportivas ainda é frequentemente realizada por canais informais, como mensagens em aplicativos, ligações telefônicas ou registros manuais. Esse processo pode gerar conflitos de horário, dificuldade de acompanhamento e pouca transparência para clientes e prestadores.

O HubArena propõe uma solução digital para centralizar reservas, organizar a agenda das quadras e permitir atualização de status das solicitações. Além disso, o projeto é adequado para a disciplina por permitir a aplicação de backend REST, banco de dados relacional, arquitetura em camadas e futura comunicação assíncrona via middleware orientado a mensagens.
""")

sections.append("""## 3. Perfis de Usuário

### Cliente

O cliente é o usuário final interessado em reservar uma quadra esportiva. Suas principais ações são:

- consultar arenas;
- visualizar quadras disponíveis;
- criar solicitações de reserva;
- acompanhar o status da reserva.

### Prestador

O prestador é o administrador da arena esportiva. Suas principais ações são:

- cadastrar arenas;
- cadastrar quadras;
- configurar dados das quadras;
- visualizar reservas;
- aceitar ou recusar solicitações.
""")

sections.append("""## 4. Funcionalidades Principais da Sprint 1

Na Sprint 1, foram implementadas as funcionalidades essenciais do backend REST:

- criação e listagem de usuários;
- consulta de usuário por ID;
- criação e listagem de arenas;
- consulta de arena por ID;
- criação e listagem de quadras;
- consulta de quadra por ID;
- criação de reserva;
- listagem de reservas;
- consulta de reserva por ID;
- aceite de reserva;
- recusa de reserva.

Essas funcionalidades representam o fluxo mínimo do domínio: um prestador cadastra sua estrutura esportiva, um cliente solicita uma reserva e o prestador atualiza o status da solicitação.
""")

sections.append("""## 5. Arquitetura Proposta

A arquitetura foi planejada como uma aplicação distribuída orientada a eventos. Na Sprint 1, foi implementado o backend REST em Flask, com persistência em PostgreSQL. A estrutura do backend segue separação em camadas:

- routes;
- controllers;
- services;
- repositories;
- models;
- database;
- config.

O sistema também prevê dois aplicativos móveis em Flutter: um para o cliente e outro para o prestador. A integração assíncrona com RabbitMQ será implementada na Sprint 2, com eventos como reservation_created, reservation_accepted e reservation_rejected.
""")

sections.append("""## 6. Tecnologias Utilizadas

- Python 3.12;
- Flask;
- Flask-SQLAlchemy;
- PostgreSQL;
- Docker Compose;
- PlantUML;
- Postman;
- requests para testes automatizados.

A escolha por Flask permite implementar uma API REST simples, objetiva e adequada ao escopo da Sprint 1. O PostgreSQL foi escolhido por oferecer persistência relacional robusta e compatível com o crescimento futuro do projeto.
""")

sections.append("""## 7. Entregas Produzidas

A Sprint 1 produziu os seguintes artefatos:

- backend REST funcional;
- banco PostgreSQL configurado via Docker Compose;
- schema documentado em docs/schema.md;
- diagrama de arquitetura em PlantUML;
- imagem do diagrama gerada em docs/diagrams;
- coleção Postman exportada;
- script automatizado de testes da API;
- relatório de execução dos testes;
- README com instruções de execução.
""")

sections.append("""## 8. Conclusão

O HubArena apresenta um domínio claro, viável e alinhado aos requisitos da disciplina. A Sprint 1 estabelece a base do sistema distribuído por meio de um backend REST funcional, persistência em PostgreSQL, documentação arquitetural e testes dos endpoints principais.

A solução está preparada para evoluir nas próximas sprints com integração assíncrona via RabbitMQ e desenvolvimento dos aplicativos móveis em Flutter.
""")

proposal = "\\n".join(sections)

output_path = Path("docs/proposta_sprint1.md")
output_path.write_text(proposal, encoding="utf-8")

print(f"Documento de proposta gerado em: {output_path}")
