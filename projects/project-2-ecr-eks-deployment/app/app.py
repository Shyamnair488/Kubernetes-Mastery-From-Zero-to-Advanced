from flask import Flask, jsonify
import os, socket

app = Flask(__name__)

@app.route("/")
def index():
    return jsonify(message="Hello from Kubernetes!",
                   pod=socket.gethostname(),
                   version=os.getenv("APP_VERSION", "v1"),
                   env=os.getenv("APP_ENV", "dev"))

@app.route("/healthz")
def health():
    return "ok", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
