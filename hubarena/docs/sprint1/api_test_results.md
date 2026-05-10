# HubArena - Resultado dos Testes Automatizados

Este relatório foi gerado automaticamente pelo script `scripts/api_smoke_test.py`.

## Criar prestador

**Método:** `POST`

**Endpoint:** `/users`

**Status HTTP:** `201`

**Resposta:**

```json
{
  "createdAt": "2026-05-10T10:27:01.546171",
  "email": "prestador_1778408821@hubarena.com",
  "id": 7,
  "name": "Arena Pampulha Teste",
  "role": "PROVIDER"
}
```

## Criar cliente

**Método:** `POST`

**Endpoint:** `/users`

**Status HTTP:** `201`

**Resposta:**

```json
{
  "createdAt": "2026-05-10T10:27:01.569152",
  "email": "cliente_1778408821@hubarena.com",
  "id": 8,
  "name": "Jose Cliente Teste",
  "role": "CLIENT"
}
```

## Criar arena

**Método:** `POST`

**Endpoint:** `/arenas`

**Status HTTP:** `201`

**Resposta:**

```json
{
  "address": "Avenida Antonio Carlos, Belo Horizonte - MG",
  "createdAt": "2026-05-10T10:27:01.583917",
  "description": "Arena criada automaticamente pelo teste Python.",
  "id": 4,
  "name": "HubArena Pampulha Teste",
  "providerId": 7
}
```

## Criar quadra

**Método:** `POST`

**Endpoint:** `/courts`

**Status HTTP:** `201`

**Resposta:**

```json
{
  "arenaId": 4,
  "available": true,
  "capacity": 10,
  "createdAt": "2026-05-10T10:27:01.599844",
  "id": 4,
  "priceHour": 120.0,
  "sport": "Futebol Society"
}
```

## Criar reserva

**Método:** `POST`

**Endpoint:** `/reservations`

**Status HTTP:** `201`

**Resposta:**

```json
{
  "clientId": 8,
  "courtId": 4,
  "createdAt": "2026-05-10T10:27:01.626191",
  "date": "2026-05-20",
  "endTime": "20:00",
  "id": 4,
  "startTime": "19:00",
  "status": "PENDING",
  "updatedAt": "2026-05-10T10:27:01.626191"
}
```

## Aceitar reserva

**Método:** `PUT`

**Endpoint:** `/reservations/4/accept`

**Status HTTP:** `200`

**Resposta:**

```json
{
  "clientId": 8,
  "courtId": 4,
  "createdAt": "2026-05-10T10:27:01.626191",
  "date": "2026-05-20",
  "endTime": "20:00",
  "id": 4,
  "startTime": "19:00",
  "status": "ACCEPTED",
  "updatedAt": "2026-05-10T10:27:01.645504"
}
```

## Listar reservas

**Método:** `GET`

**Endpoint:** `/reservations`

**Status HTTP:** `200`

**Resposta:**

```json
[
  {
    "clientId": 2,
    "courtId": 1,
    "createdAt": "2026-05-10T09:39:50.110297",
    "date": "2026-05-15",
    "endTime": "20:00",
    "id": 1,
    "startTime": "19:00",
    "status": "ACCEPTED",
    "updatedAt": "2026-05-10T09:40:00.808084"
  },
  {
    "clientId": 4,
    "courtId": 2,
    "createdAt": "2026-05-10T10:04:22.405160",
    "date": "2026-05-20",
    "endTime": "20:00",
    "id": 2,
    "startTime": "19:00",
    "status": "ACCEPTED",
    "updatedAt": "2026-05-10T10:04:22.427661"
  },
  {
    "clientId": 6,
    "courtId": 3,
    "createdAt": "2026-05-10T10:21:42.065952",
    "date": "2026-05-20",
    "endTime": "20:00",
    "id": 3,
    "startTime": "19:00",
    "status": "ACCEPTED",
    "updatedAt": "2026-05-10T10:21:42.085637"
  },
  {
    "clientId": 8,
    "courtId": 4,
    "createdAt": "2026-05-10T10:27:01.626191",
    "date": "2026-05-20",
    "endTime": "20:00",
    "id": 4,
    "startTime": "19:00",
    "status": "ACCEPTED",
    "updatedAt": "2026-05-10T10:27:01.645504"
  }
]
```
