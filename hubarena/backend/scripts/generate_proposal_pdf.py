from pathlib import Path
from fpdf import FPDF


ROOT_MD = Path("../docs/sprint1/proposta_sprint1.md")
BACKEND_MD = Path("docs/proposta_sprint1.md")
ROOT_PDF = Path("../docs/sprint1/proposta_sprint1.pdf")
BACKEND_PDF = Path("docs/proposta_sprint1.pdf")


class ProposalPDF(FPDF):
    def header(self):
        self.set_font("Arial", "B", 10)
        self.cell(0, 7, "HubArena - Proposta de Dominio - Sprint 1", 0, 1, "C")
        self.ln(1)

    def footer(self):
        self.set_y(-11)
        self.set_font("Arial", "I", 8)
        self.cell(0, 8, f"Pagina {self.page_no()}", 0, 0, "C")


def normalize(text):
    replacements = {
        "á": "a", "à": "a", "ã": "a", "â": "a",
        "é": "e", "ê": "e",
        "í": "i",
        "ó": "o", "ô": "o", "õ": "o",
        "ú": "u",
        "ç": "c",
        "Á": "A", "À": "A", "Ã": "A", "Â": "A",
        "É": "E", "Ê": "E",
        "Í": "I",
        "Ó": "O", "Ô": "O", "Õ": "O",
        "Ú": "U",
        "Ç": "C",
        "–": "-",
        "—": "-",
        "“": '"',
        "”": '"',
        "’": "'",
        "`": "",
        "|": " ",
    }

    for old, new in replacements.items():
        text = text.replace(old, new)

    return text


def render_pdf(markdown_path, output_path):
    text = markdown_path.read_text(encoding="utf-8")
    text = normalize(text)

    pdf = ProposalPDF()
    pdf.set_auto_page_break(auto=True, margin=11)
    pdf.set_left_margin(13)
    pdf.set_right_margin(13)
    pdf.add_page()

    for raw_line in text.splitlines():
        line = raw_line.strip()

        if not line:
            pdf.ln(1.5)
            continue

        if line.startswith("# "):
            pdf.set_font("Arial", "B", 13)
            pdf.multi_cell(0, 6, line.replace("# ", ""))
            pdf.ln(1)

        elif line.startswith("## "):
            pdf.set_font("Arial", "B", 9.5)
            pdf.multi_cell(0, 5, line.replace("## ", ""))
            pdf.ln(0.5)

        elif line.startswith("### "):
            pdf.set_font("Arial", "B", 8.7)
            pdf.multi_cell(0, 4.5, line.replace("### ", ""))

        elif line.startswith("- "):
            pdf.set_font("Arial", "", 7.8)
            pdf.multi_cell(0, 3.8, "- " + line[2:])

        elif line.startswith("|"):
            # Tabelas markdown sao compactadas no PDF como texto simples.
            pdf.set_font("Arial", "", 6.7)
            pdf.multi_cell(0, 3.2, line)

        else:
            pdf.set_font("Arial", "", 7.8)
            pdf.multi_cell(0, 3.8, line)

    output_path.parent.mkdir(parents=True, exist_ok=True)
    pdf.output(str(output_path))


def main():
    if not ROOT_MD.exists():
        raise FileNotFoundError(f"Arquivo nao encontrado: {ROOT_MD}")

    BACKEND_MD.write_text(ROOT_MD.read_text(encoding="utf-8"), encoding="utf-8")

    render_pdf(ROOT_MD, ROOT_PDF)
    render_pdf(BACKEND_MD, BACKEND_PDF)

    print(f"PDF atualizado em: {ROOT_PDF}")
    print(f"PDF atualizado em: {BACKEND_PDF}")


if __name__ == "__main__":
    main()
