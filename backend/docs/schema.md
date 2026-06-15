# HubArena - Schema do Banco de Dados

Banco utilizado: PostgreSQL.

## Tabela: users

Armazena os usuários da plataforma, podendo representar clientes ou prestadores.

| Campo | Tipo | Descrição |
|---|---|---|
| id | Integer | Identificador único |
| name | String | Nome do usuário |
| email | String | E-mail único |
| password | String | Senha do usuário |
| role | String | CLIENT ou PROVIDER |
| created_at | DateTime | Data de criação |

## Tabela: arenas

Armazena os estabelecimentos esportivos cadastrados por prestadores.

| Campo | Tipo | Descrição |
|---|---|---|
| id | Integer | Identificador único |
| provider_id | Integer | Usuário prestador responsável |
| name | String | Nome da arena |
| description | Text | Descrição da arena |
| address | String | Endereço |
| created_at | DateTime | Data de criação |

## Tabela: courts

Armazena as quadras pertencentes a uma arena.

| Campo | Tipo | Descrição |
|---|---|---|
| id | Integer | Identificador único |
| arena_id | Integer | Arena vinculada |
| sport | String | Modalidade esportiva |
| price_hour | Float | Valor por hora |
| capacity | Integer | Capacidade da quadra |
| available | Boolean | Disponibilidade da quadra |
| created_at | DateTime | Data de criação |

## Tabela: reservations

Armazena as reservas feitas por clientes.

| Campo | Tipo | Descrição |
|---|---|---|
| id | Integer | Identificador único |
| client_id | Integer | Cliente responsável pela reserva |
| court_id | Integer | Quadra reservada |
| date | Date | Data da reserva |
| start_time | Time | Horário inicial |
| end_time | Time | Horário final |
| status | String | PENDING, ACCEPTED ou REJECTED |
| created_at | DateTime | Data de criação |
| updated_at | DateTime | Última atualização |

## Relacionamentos

- Um usuário PROVIDER pode possuir várias arenas.
- Uma arena pode possuir várias quadras.
- Uma quadra pode possuir várias reservas.
- Um usuário CLIENT pode possuir várias reservas.
