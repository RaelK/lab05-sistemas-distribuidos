from flask import Flask, request, jsonify
import grpc
import sys
import os

# permitir importar arquivos do gRPC
sys.path.append("../t3_grpc")

import calculadora_pb2
import calculadora_pb2_grpc

app = Flask(__name__)

# conexão com o servidor gRPC
channel = grpc.insecure_channel("localhost:50051")
stub = calculadora_pb2_grpc.CalculadoraStub(channel)


@app.route("/soma", methods=["GET"])
def soma():
    try:
        a = int(request.args.get("a"))
        b = int(request.args.get("b"))

        resposta = stub.Soma(calculadora_pb2.Numeros(a=a, b=b))

        return jsonify({"resultado": resposta.resultado})

    except Exception as e:
        return jsonify({"erro": str(e)}), 500


@app.route("/subtrai", methods=["GET"])
def subtrai():
    try:
        a = int(request.args.get("a"))
        b = int(request.args.get("b"))

        resposta = stub.Subtrai(calculadora_pb2.Numeros(a=a, b=b))

        return jsonify({"resultado": resposta.resultado})

    except Exception as e:
        return jsonify({"erro": str(e)}), 500


if __name__ == "__main__":
    app.run(port=7000)