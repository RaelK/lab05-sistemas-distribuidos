# Sprint 3 — Aplicativo Flutter Cliente

## 1. Objetivo

Desenvolver o aplicativo Flutter destinado ao cliente do HubArena, permitindo consultar quadras esportivas, visualizar detalhes, criar reservas e acompanhar automaticamente o status das reservas.

A Sprint 3 implementa o aplicativo móvel do cliente com integração ao backend REST Flask desenvolvido nas Sprints 1 e 2. A atualização assíncrona foi implementada por polling automático.

## 2. Funcionalidades implementadas

- Tela inicial com listagem de quadras esportivas.
- Tela de detalhes da quadra.
- Tela de criação de reserva.
- Tela "Minhas reservas".
- Integração com backend REST.
- Atualização automática de reservas por polling.
- Layout com identidade visual esportiva.
- Geração de APK Android.

## 3. Telas do aplicativo

### 3.1 Tela inicial

Apresenta o banner principal do HubArena, ícones esportivos e a listagem das quadras disponíveis.

### 3.2 Detalhes da quadra

Exibe modalidade esportiva, arena, preço por hora, capacidade e disponibilidade.

### 3.3 Criar reserva

Permite ao cliente selecionar data, horário inicial e horário final para solicitar uma reserva.

### 3.4 Minhas reservas

Exibe as reservas do cliente e atualiza automaticamente o status a cada 5 segundos.

## 4. Integração REST

O aplicativo consome os seguintes endpoints do backend:

| Método | Endpoint | Função |
|---|---|---|
| GET | `/arenas` | Listar arenas |
| GET | `/courts` | Listar quadras |
| GET | `/reservations` | Listar reservas |
| POST | `/reservations` | Criar reserva |

Para validação do fluxo assíncrono via polling, os seguintes endpoints foram usados no Postman:

| Método | Endpoint | Função |
|---|---|---|
| PUT | `/reservations/{id}/accept` | Aceitar reserva |
| PUT | `/reservations/{id}/reject` | Recusar reserva |

## 5. Atualização assíncrona

A tela "Minhas reservas" executa polling automático em `GET /reservations` a cada 5 segundos.

Fluxo validado:

1. Cliente cria uma reserva pelo aplicativo.
2. Backend grava a reserva no banco com status `PENDING`.
3. Aplicativo exibe a reserva como `PENDENTE`.
4. Pelo Postman, o status é alterado usando `PUT /reservations/{id}/accept`.
5. O aplicativo atualiza sozinho para `ACEITA`, sem ação manual do usuário.

## 6. Arquitetura do aplicativo Flutter

A estrutura segue separação por camadas, inspirada em Clean Architecture:

```text
lib/
├── core/
│   ├── config/
│   │   └── app_config.dart
│   └── theme/
│       └── app_theme.dart
├── data/
│   ├── models/
│   │   ├── arena.dart
│   │   ├── court.dart
│   │   └── reservation.dart
│   └── services/
│       └── api_service.dart
├── presentation/
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── court_details_screen.dart
│   │   ├── create_reservation_screen.dart
│   │   └── reservations_screen.dart
│   └── widgets/
│       ├── court_card.dart
│       └── status_badge.dart
└── main.dart>> EOF
eof
