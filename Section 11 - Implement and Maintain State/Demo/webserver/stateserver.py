from flask import Flask, request, jsonify
import os
import logging

app = Flask(__name__)

STATE_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "states")
os.makedirs(STATE_DIR, exist_ok=True)

lock_store = {}

logging.basicConfig(level=logging.DEBUG)

@app.route("/")
def index():
    return "<h1>Terraform State Server</h1>"

@app.route("/terraform_state/<state_id>", methods=["GET", "POST"])
def state(state_id):
    state_file = os.path.join(STATE_DIR, f"{state_id}.tfstate")
    if request.method == "GET":
        app.logger.info(f"GET state: {state_id}")
        if not os.path.exists(state_file):
            return "", 404
        with open(state_file, "r") as f:
            return app.response_class(f.read(), content_type="application/json")
    elif request.method == "POST":
        app.logger.info(f"POST state: {state_id}")
        with open(state_file, "w") as f:
            f.write(request.get_data(as_text=True))
        return "", 200

@app.route("/terraform_lock/<state_id>", methods=["PUT", "DELETE"])
def lock(state_id):
    if request.method == "PUT":
        app.logger.info(f"LOCK: {state_id}")
        if state_id in lock_store:
            return jsonify(lock_store[state_id]), 423
        lock_store[state_id] = request.json
        return "", 200
    elif request.method == "DELETE":
        app.logger.info(f"UNLOCK: {state_id}")
        lock_store.pop(state_id, None)
        return "", 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
