import requests

r1 = requests.get("http://127.0.0.1:5000/soma?a=10&b=5")
print("Soma:", r1.json())

r2 = requests.get("http://127.0.0.1:5000/subtrai?a=10&b=5")
print("Subtração:", r2.json())