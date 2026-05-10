from pathlib import Path
from fpdf import FPDF


PROPOSAL_MD = Path("docs/proposta_sprint1.md")
PROPOSAL_PDF = Path("docs/proposta_sprint1.pdf")


content = """# Proposta de Domínio - HubArena

## Domínio escolhido

O HubArena é uma plataforma distribuída para reserva de quadras esportivas. O sistema conecta clientes interessados em reservar espaços esportivos com prestadores responsáveis por arenas, quadras e horários disponíveis. O domínio atende ao modelo cliente/prestador exigido pela disciplina, pois existe uma separação clara entre quem solicita o serviço e quem gerencia a oferta.

## Justificativa

A reserva de quadras esportivas ainda ocorre, em muitos casos, por mensagens, ligações ou controles manuais. Esse processo dificulta a organização da agenda, aumenta o risco de conflitos de horário e reduz a transparência para clientes e prestadores. O HubArena propõe centralizar esse fluxo em uma API REST, com persistência em PostgreSQL e arquitetura preparada para eventos assíncronos via RabbitMQ nas próximas sprints.

## Perfis de usuário

Cliente: usuário final que consulta arenas, visualiza quadras disponíveis, cria solicitações de reserva e acompanha o status da reserva.

Prestador: administrador da arena esportiva, responsável por cadastrar arenas, cadastrar quadras, gerenciar disponibilidade e aceitar ou recusar reservas.

## Funcionalidades principais da Sprint 1

Na Sprint 1 foram implementadas as funcionalidades essenciais do backend REST: criação e listagem de usuários, consulta de usuários por ID, criação e listagem de arenas, consulta de arenas por ID, criação e listagem de quadras, consulta de quadras por ID, criação de reservas, listagem de reservas, consulta de reservas por ID, aceite e recusa de reservas.

## Arquitetura

O backend foi implementado em Flask/Python e organizado em camadas: routes, controllers, services, repositories, models, database e config. A persistência foi feita com PostgreSQL via SQLAlchemy. A arquitetura contempla dois aplicativos móveis futuros em Flutter, um para cliente e outro para prestador, além de RabbitMQ como middleware orientado a mensagens previsto para a Sprint 2.

## Tecnologias utilizadas

Python 3.12, Flask, Flask-SQLAlchemy, Flask-CORS, PostgreSQL, Docker Compose, pg8000, PlantUML, Postman e requests para testes automatizados.

## Entregas produzidas

Foram produzidos backend REST funcional, schema documentado, diagrama de arquitetura em PlantUML, imagem do diagrama, coleção Postman, relatório de testes automatizados, README com instruções de execução e scripts auxiliares de geração de documentação.

## Conclusão

A Sprint 1 estabelece uma base funcional e viável para o HubArena. O sistema já possui backend REST persistente, endpoints testados e organização de código compatível com boas práticas. A solução está preparada para evoluir na Sprint 2 com integração assíncrona por RabbitMQ.
"""


def clean_text(text):
    replacements = {
        "–": "-",
        "—": "-",
        "“": '"',
        "”": '"',
        "’": "'",
        "•": "-",
    }

    for old, new in replacements.items():
        text = text.replace(old, new)

    return text


class ProposalPDF(FPDF):
    def header(self):
        self.set_font("Arial", "B", 11)
        self.cell(0, 8, "HubArena - Proposta de Dominio - Sprint 1", 0, 1, "C")
        self.ln(2)

    def footer(self):
        self.set_y(-12)
        self.set_font("Arial", "I", 8)
        self.cell(0, 8, f"Pagina {self.page_no()}", 0, 0, "C")


def write_markdown():
    PROPOSAL_MD.write_text(content, encoding="utf-8")
    print(f"Markdown gerado em: {PROPOSAL_MD}")


def write_pdf():
    pdf = ProposalPDF()
    pdf.set_auto_page_break(auto=True, margin=12)
    pdf.add_page()
    pdf.set_left_margin(14)
    pdf.set_right_margin(14)

    for raw_line in clean_text(content).splitlines():
        line = raw_line.strip()

        if not line:
            pdf.ln(2)
            continue

        if line.startswith("# "):
            pdf.set_font("Arial", "B", 14)
            pdf.multi_cell(0, 7, line.replace("# ", ""))
            pdf.ln(1)

        elif line.startswith("## "):
            pdf.set_font("Arial", "B", 11)
            pdf.multi_cell(0, 6, line.replace("## ", ""))
            pdf.ln(1)

        else:
            pdf.set_font("Arial", "", 9)
            pdf.multi_cell(0, 4.6, line)

    pdf.output(str(PROPOSAL_PDF))
    print(f"PDF gerado em: {PROPOSAL_PDF}")


if __name__ == "__main__":
    write_markdown()
    write_pdf()
