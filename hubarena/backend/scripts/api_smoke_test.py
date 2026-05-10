import json
import time
from pathlib import Path

import requests


BASE_URL = "http://127.0.0.1:5000"


def send_request(method, endpoint, payload=None):
    url = f"{BASE_URL}{endpoint}"

    response = requests.request(
        method=method,
        url=url,
        json=payload,
        timeout=10
    )

    try:
        body = response.json()
    except ValueError:
        body = response.text

    return {
        "method": method,
        "endpoint": endpoint,
        "status_code": response.status_code,
        "body": body
    }


def format_json(data):
    return json.dumps(data, indent=2, ensure_ascii=False)


def main():
    timestamp = int(time.time())
    results = []

    provider_payload = {
        "name": "Arena Pampulha Teste",
        "email": f"prestador_{timestamp}@hubarena.com",
        "password": "123456",
        "role": "PROVIDER"
    }

    provider_result = send_request("POST", "/users", provider_payload)
    results.append(("Criar prestador", provider_result))
    provider_id = provider_result["body"]["id"]

    client_payload = {
        "name": "Jose Cliente Teste",
        "email": f"cliente_{timestamp}@hubarena.com",
        "password": "123456",
        "role": "CLIENT"
    }

    client_result = send_request("POST", "/users", client_payload)
    results.append(("Criar cliente", client_result))
    client_id = client_result["body"]["id"]

    arena_payload = {
        "providerId": provider_id,
        "name": "HubArena Pampulha Teste",
        "description": "Arena criada automaticamente pelo teste Python.",
        "address": "Avenida Antonio Carlos, Belo Horizonte - MG"
    }

    arena_result = send_request("POST", "/arenas", arena_payload)
    results.append(("Criar arena", arena_result))
    arena_id = arena_result["body"]["id"]

    court_payload = {
        "arenaId": arena_id,
        "sport": "Futebol Society",
        "priceHour": 120.0,
        "capacity": 10,
        "available": True
    }

    court_result = send_request("POST", "/courts", court_payload)
    results.append(("Criar quadra", court_result))
    court_id = court_result["body"]["id"]

    reservation_payload = {
        "clientId": client_id,
        "courtId": court_id,
        "date": "2026-05-20",
        "startTime": "19:00",
        "endTime": "20:00"
    }

    reservation_result = send_request("POST", "/reservations", reservation_payload)
    results.append(("Criar reserva", reservation_result))
    reservation_id = reservation_result["body"]["id"]

    accept_result = send_request("PUT", f"/reservations/{reservation_id}/accept")
    results.append(("Aceitar reserva", accept_result))

    list_result = send_request("GET", "/reservations")
    results.append(("Listar reservas", list_result))

    report = []
    report.append("# HubArena - Resultado dos Testes Automatizados")
    report.append("")
    report.append("Este relatório foi gerado automaticamente pelo script `scripts/api_smoke_test.py`.")
    report.append("")

    for title, result in results:
        report.append(f"## {title}")
        report.append("")
        report.append(f"**Método:** `{result['method']}`")
        report.append("")
        report.append(f"**Endpoint:** `{result['endpoint']}`")
        report.append("")
        report.append(f"**Status HTTP:** `{result['status_code']}`")
        report.append("")
        report.append("**Resposta:**")
        report.append("")
        report.append("```json")
        report.append(format_json(result["body"]))
        report.append("```")
        report.append("")

    output_path = Path("docs/api_test_results.md")
    output_path.write_text("\n".join(report), encoding="utf-8")

    print("Testes automatizados executados com sucesso.")
    print(f"Relatório gerado em: {output_path}")


if __name__ == "__main__":
    main()
