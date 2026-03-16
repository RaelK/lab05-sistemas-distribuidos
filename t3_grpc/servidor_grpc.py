import grpc
from concurrent import futures
import time

import calculadora_pb2
import calculadora_pb2_grpc


class CalculadoraServicer(calculadora_pb2_grpc.CalculadoraServicer):

    def Soma(self, request, context):
        resultado = request.a + request.b
        return calculadora_pb2.Resultado(resultado=resultado)

    def Subtrai(self, request, context):
        resultado = request.a - request.b
        return calculadora_pb2.Resultado(resultado=resultado)


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    calculadora_pb2_grpc.add_CalculadoraServicer_to_server(
        CalculadoraServicer(), server
    )

    server.add_insecure_port("[::]:50051")
    server.start()

    print("Servidor gRPC rodando na porta 50051")

    try:
        while True:
            time.sleep(86400)
    except KeyboardInterrupt:
        server.stop(0)


if __name__ == "__main__":
    serve()