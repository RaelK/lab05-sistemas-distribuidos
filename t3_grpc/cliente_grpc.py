import grpc

import calculadora_pb2
import calculadora_pb2_grpc


def run():
    channel = grpc.insecure_channel("localhost:50051")
    stub = calculadora_pb2_grpc.CalculadoraStub(channel)

    resposta1 = stub.Soma(calculadora_pb2.Numeros(a=10, b=5))
    print("Soma:", resposta1.resultado)

    resposta2 = stub.Subtrai(calculadora_pb2.Numeros(a=10, b=5))
    print("Subtração:", resposta2.resultado)


if __name__ == "__main__":
    run()