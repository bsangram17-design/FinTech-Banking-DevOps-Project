from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route("/health")
def health():
    return jsonify(status="UP")

@app.route("/balance")
def balance():
    return jsonify(
        account="XXXX1234",
        balance="₹50,000",
        currency="INR"
    )

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
