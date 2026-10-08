"""Demo Shop - internal orders API (fixed version)."""
import ipaddress
import os
import sqlite3
import subprocess

from flask import Flask, abort, request

app = Flask(__name__)

# Secrets: nothing in the code. In production, the app gets short-lived credentials
# through its workload identity (e.g. IAM role / OIDC) - there are no static keys.
DB_PATH = os.environ.get("DB_PATH", "shop.db")


def get_db():
    return sqlite3.connect(DB_PATH)


@app.route("/orders")
def orders():
    customer = request.args.get("customer", "")
    db = get_db()
    # Parameterised query: the input is never interpreted as SQL
    rows = db.execute("SELECT * FROM orders WHERE customer = ?", (customer,)).fetchall()
    return {"result": rows}


@app.route("/ping")
def ping():
    host = request.args.get("host", "127.0.0.1")
    try:
        ipaddress.ip_address(host)  # allowlist: only accept valid IPs
    except ValueError:
        abort(400)
    # Argument list, no shell
    out = subprocess.check_output(["ping", "-c", "1", host])
    return out


# /proxy removed: an open proxy is SSRF by design. If you really need one,
# use a fixed allowlist of destinations and keep verify=True.

if __name__ == "__main__":
    app.run(host="127.0.0.1", debug=False)
