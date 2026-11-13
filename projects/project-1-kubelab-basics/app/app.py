import os, socket, time
import psycopg2
from flask import Flask, jsonify

app = Flask(__name__)

def conn():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "postgres"),
        dbname=os.getenv("DB_NAME", "kubelab"),
        user=os.getenv("DB_USER", "kubelab"),
        password=os.getenv("DB_PASSWORD", "kubelab"),
        connect_timeout=3,
    )

def init_db():
    for _ in range(30):
        try:
            with conn() as c, c.cursor() as cur:
                cur.execute("CREATE TABLE IF NOT EXISTS visits (id SERIAL PRIMARY KEY, pod TEXT, ts TIMESTAMP DEFAULT now())")
            return
        except Exception as e:
            print("waiting for db:", e, flush=True)
            time.sleep(2)

@app.route("/api/visit")
def visit():
    with conn() as c, c.cursor() as cur:
        cur.execute("INSERT INTO visits(pod) VALUES (%s)", (socket.gethostname(),))
        cur.execute("SELECT count(*) FROM visits")
        total = cur.fetchone()[0]
    return jsonify(visits=total, pod=socket.gethostname(), version=os.getenv("APP_VERSION", "1.0"))

@app.route("/api/cpu")
def cpu():                      # burn CPU for HPA demos
    x = 0
    for i in range(3_000_000):
        x += i * i
    return jsonify(done=True)

@app.route("/healthz")
def healthz():
    return "ok"

@app.route("/readyz")
def readyz():
    try:
        with conn() as c, c.cursor() as cur:
            cur.execute("SELECT 1")
        return "ready"
    except Exception:
        return "db not ready", 503

init_db()
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
