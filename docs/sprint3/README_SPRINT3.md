# Sprint 3 — Aplicativo Flutter Cliente

## Objetivo

Desenvolver o aplicativo Flutter destinado ao cliente do HubArena, permitindo consultar quadras esportivas, visualizar detalhes, criar reservas e acompanhar o status das reservas com atualização automática.

## Funcionalidades implementadas

- Listagem de quadras esportivas disponíveis.
- Tela de detalhes da quadra.
- Criação de reserva pelo cliente.
- Tela "Minhas reservas".
- Integração com backend REST Flask.
- Atualização assíncrona por polling automático a cada 5 segundos.
- Layout com identidade esportiva.

## Integração REST

O aplicativo consome:

- `GET /arenas`
- `GET /courts`
- `GET /reservations`
- `POST /reservations`

Para validação do polling:

- `PUT /reservations/{id}/accept`
- `PUT /reservations/{id}/reject`

## Atualização assíncrona

A tela "Minhas reservas" executa polling automático em `GET /reservations` a cada 5 segundos. Quando o status da reserva é alterado no backend, o aplicativo reflete a mudança sem ação manual do usuário.

Fluxo validado:

1. Cliente cria reserva pelo app.
2. Backend registra reserva com status `PENDING`.
3. App exibe a reserva como `PENDENTE`.
4. Status é alterado no Postman para `ACCEPTED`.
5. App atualiza automaticamente para `ACEITA`.

## Arquitetura Flutter

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
└── main.dart
