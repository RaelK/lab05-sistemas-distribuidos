from flask import Flask, jsonify, request

app = Flask(__name__)

@app.route("/soma", methods=["GET"])
def soma():
    a = int(request.args.get("a"))
    b = int(request.args.get("b"))
    return jsonify({"resultado": a + b})

@app.route("/subtrai", methods=["GET"])
def subtrai():
    a = int(request.args.get("a"))
    b = int(request.args.get("b"))
    return jsonify({"resultado": a - b})

if __name__ == "__main__":
    app.run(port=5000)