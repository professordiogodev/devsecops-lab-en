"""Demo Shop - internal orders API (VULNERABLE ON PURPOSE - for the lab only)."""
import sqlite3
import subprocess

import requests
from flask import Flask, request

app = Flask(__name__)

# TODO: move to environment variables "later"...
AWS_ACCESS_KEY_ID = "AKIAQYLPMN5HHHFPZAM2"
AWS_SECRET_ACCESS_KEY = "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"
GITHUB_TOKEN = "ghp_4bQm7Xr2Lk9Tz8Wv3Np6Ys1Hc5Jd0Fg2Ae7R"


def get_db():
    return sqlite3.connect("shop.db")


@app.route("/orders")
def orders():
    customer = request.args.get("customer", "")
    db = get_db()
    # User input concatenated straight into a SQL query
    query = f"SELECT * FROM orders WHERE customer = '{customer}'"
    return {"result": db.execute(query).fetchall()}


@app.route("/ping")
def ping():
    host = request.args.get("host", "localhost")
    # User input passed to a shell
    out = subprocess.check_output("ping -c 1 " + host, shell=True)
    return out


@app.route("/proxy")
def proxy():
    url = request.args.get("url")
    # No destination validation and no TLS verification
    return requests.get(url, verify=False).text


if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
