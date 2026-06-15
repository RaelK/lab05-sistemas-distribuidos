import json
from pathlib import Path


BASE_URL = "http://127.0.0.1:5000"


def request_item(name, method, endpoint, body=None):
    item = {
        "name": name,
        "request": {
            "method": method,
            "header": [],
            "url": f"{BASE_URL}{endpoint}"
        }
    }

    if body is not None:
        item["request"]["header"] = [
            {
                "key": "Content-Type",
                "value": "application/json"
            }
        ]
        item["request"]["body"] = {
            "mode": "raw",
            "raw": json.dumps(body, indent=2, ensure_ascii=False),
            "options": {
                "raw": {
                    "language": "json"
                }
            }
        }

    return item


collection = {
    "info": {
        "name": "HubArena - Sprint 1",
        "description": "Coleção Postman dos endpoints REST implementados na Sprint 1 do HubArena.",
        "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    },
    "item": [
        {
            "name": "Health",
            "item": [
                request_item("Health Check", "GET", "/health"),
                request_item("Database Health Check", "GET", "/health/db")
            ]
        },
        {
            "name": "Users",
            "item": [
                request_item(
                    "Create Provider",
                    "POST",
                    "/users",
                    {
                        "name": "Arena Pampulha",
                        "email": "prestador@hubarena.com",
                        "password": "123456",
                        "role": "PROVIDER"
                    }
                ),
                request_item(
                    "Create Client",
                    "POST",
                    "/users",
                    {
                        "name": "Jose Cliente",
                        "email": "cliente@hubarena.com",
                        "password": "123456",
                        "role": "CLIENT"
                    }
                ),
                request_item("List Users", "GET", "/users"),
                request_item("Get User By ID", "GET", "/users/1")
            ]
        },
        {
            "name": "Arenas",
            "item": [
                request_item(
                    "Create Arena",
                    "POST",
                    "/arenas",
                    {
                        "providerId": 1,
                        "name": "HubArena Pampulha",
                        "description": "Arena esportiva com quadras de futebol society e futsal.",
                        "address": "Avenida Antonio Carlos, Belo Horizonte - MG"
                    }
                ),
                request_item("List Arenas", "GET", "/arenas"),
                request_item("Get Arena By ID", "GET", "/arenas/1")
            ]
        },
        {
            "name": "Courts",
            "item": [
                request_item(
                    "Create Court",
                    "POST",
                    "/courts",
                    {
                        "arenaId": 1,
                        "sport": "Futebol Society",
                        "priceHour": 120.0,
                        "capacity": 10,
                        "available": True
                    }
                ),
                request_item("List Courts", "GET", "/courts"),
                request_item("Get Court By ID", "GET", "/courts/1")
            ]
        },
        {
            "name": "Reservations",
            "item": [
                request_item(
                    "Create Reservation",
                    "POST",
                    "/reservations",
                    {
                        "clientId": 2,
                        "courtId": 1,
                        "date": "2026-05-15",
                        "startTime": "19:00",
                        "endTime": "20:00"
                    }
                ),
                request_item("List Reservations", "GET", "/reservations"),
                request_item("Get Reservation By ID", "GET", "/reservations/1"),
                request_item("Accept Reservation", "PUT", "/reservations/1/accept"),
                request_item("Reject Reservation", "PUT", "/reservations/1/reject")
            ]
        }
    ]
}


output_path = Path("postman/HubArena_Sprint1.postman_collection.json")
output_path.parent.mkdir(parents=True, exist_ok=True)
output_path.write_text(
    json.dumps(collection, indent=2, ensure_ascii=False),
    encoding="utf-8"
)

print(f"Coleção Postman gerada com sucesso em: {output_path}")
