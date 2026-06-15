import zlib
import requests
from pathlib import Path


PLANTUML_SERVER = "https://www.plantuml.com/plantuml"


def encode_6bit(value):
    if value < 10:
        return chr(48 + value)

    value -= 10

    if value < 26:
        return chr(65 + value)

    value -= 26

    if value < 26:
        return chr(97 + value)

    value -= 26

    if value == 0:
        return "-"

    if value == 1:
        return "_"

    return "?"


def append_3bytes(byte1, byte2, byte3):
    c1 = byte1 >> 2
    c2 = ((byte1 & 0x3) << 4) | (byte2 >> 4)
    c3 = ((byte2 & 0xF) << 2) | (byte3 >> 6)
    c4 = byte3 & 0x3F

    return (
        encode_6bit(c1 & 0x3F)
        + encode_6bit(c2 & 0x3F)
        + encode_6bit(c3 & 0x3F)
        + encode_6bit(c4 & 0x3F)
    )


def plantuml_encode(text):
    compressed = zlib.compress(text.encode("utf-8"))[2:-4]

    result = ""

    for i in range(0, len(compressed), 3):
        if i + 2 == len(compressed):
            result += append_3bytes(compressed[i], compressed[i + 1], 0)
        elif i + 1 == len(compressed):
            result += append_3bytes(compressed[i], 0, 0)
        else:
            result += append_3bytes(
                compressed[i],
                compressed[i + 1],
                compressed[i + 2]
            )

    return result


def generate_diagram(input_file, output_file, output_format="png"):
    input_path = Path(input_file)
    output_path = Path(output_file)

    if not input_path.exists():
        raise FileNotFoundError(f"Arquivo não encontrado: {input_file}")

    plantuml_code = input_path.read_text(encoding="utf-8")
    encoded_code = plantuml_encode(plantuml_code)

    url = f"{PLANTUML_SERVER}/{output_format}/{encoded_code}"

    response = requests.get(url, timeout=30)
    response.raise_for_status()

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_bytes(response.content)

    print(f"Diagrama gerado com sucesso: {output_path}")


if __name__ == "__main__":
    generate_diagram(
        input_file="docs/architecture.puml",
        output_file="docs/diagrams/hubarena_architecture.png",
        output_format="png"
    )
