# app.py
import json
from flask import Flask, request, jsonify

app = Flask(__name__)

# Simple in-memory database: account_id -> balance
accounts = {
    "12345": 1000.00,
    "67890": 500.00
}

@app.route('/')
def health_check():
    """Simple health check endpoint."""
    return jsonify(status="OK", message="Fintech Banking App Running"), 200

@app.route('/balance/<account_id>', methods=['GET'])
def get_balance(account_id):
    """Retrieve the balance for a specific account."""
    balance = accounts.get(account_id)
    if balance is not None:
        return jsonify(account_id=account_id, balance=balance), 200
    else:
        return jsonify(error="Account not found"), 404

@app.route('/transfer', methods=['POST'])
def transfer_funds():
    """Transfer funds between accounts."""
    data = request.get_json()
    from_account = data.get('from')
    to_account = data.get('to')
    amount = data.get('amount')

    if not all([from_account, to_account, amount]) or amount <= 0:
        return jsonify(error="Invalid input data"), 400

    if from_account not in accounts or to_account not in accounts:
        return jsonify(error="One or both accounts not found"), 404

    if accounts[from_account] >= amount:
        accounts[from_account] -= amount
        accounts[to_account] += amount
        return jsonify(
            message="Transfer successful",
            new_balances={
                from_account: accounts[from_account],
                to_account: accounts[to_account]
            }
        ), 200
    else:
        return jsonify(error="Insufficient funds"), 400

if __name__ == '__main__':
    # Listen on all interfaces (0.0.0.0) for Docker compatibility
    app.run(debug=True, host='0.0.0.0', port=5000)
