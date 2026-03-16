from xmlrpc.server import SimpleXMLRPCServer

def soma(a, b):
    return a + b

def subtrai(a, b):
    return a - b

server = SimpleXMLRPCServer(("localhost", 8000))
print("Servidor XML-RPC rodando na porta 8000")

server.register_function(soma, "soma")
server.register_function(subtrai, "subtrai")

server.serve_forever()