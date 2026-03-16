import xmlrpc.client

proxy = xmlrpc.client.ServerProxy("http://localhost:8000/")

print("Soma:", proxy.soma(10, 5))
print("Subtração:", proxy.subtrai(10, 5))