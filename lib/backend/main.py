import os
import pandas as pd
from fastapi import FastAPI
from pydantic import BaseModel
from ml_model import predict_spending
from llm_chain import generate_card_recommendation

app = FastAPI()

# Path to the Excel file containing transactions
TRANSACTIONS_FILE = "../data/bank.xlsx"  # Update with your actual file path

def load_transactions():
    """Load transactions from an Excel file and format them into a structured list."""
    if not os.path.exists(TRANSACTIONS_FILE):
        return []
    
    # Read Excel file
    df = pd.read_excel(TRANSACTIONS_FILE, engine="openpyxl")

    # Rename columns to match expected fields
    df = df.rename(columns={
        "Account No": "account_no",
        "DATE": "date",
        "WITHDRAWAL AMT": "amount",
        "TRANSACTION DETAILS": "category"
    })

    # Remove NaN values in 'amount' column (i.e., deposits)
    df = df.dropna(subset=["amount"])

    # Convert DataFrame to list of transaction dictionaries
    transactions = df[["account_no", "date", "amount", "category"]].to_dict(orient="records")
    amounts = [(txn["amount"] / 84) for txn in transactions]  # Extract amounts as a list
    # print(transactions)
    return transactions, amounts

@app.get("/spending_analysis/{account_no}")
def spending_analysis(account_no: str):
    """Analyze user spending based on past transactions."""
    print("hi")
    transactions, amount = load_transactions()
    print(transactions)
    # Filter transactions for the given account number
    user_transactions = [t for t in transactions if str(t["account_no"]) == str(account_no)]
    dates = [t['date'] for t in transactions if str(t["account_no"]) == str(account_no)]
    print("")
    print("")
    print("")
    print(dates)
    if not user_transactions:
        return {"message": "No transactions found for this account."}

    prediction = predict_spending(user_transactions)
    prediction = [ p/84 for p in prediction]
    mean_prediction = sum(prediction) / len(prediction)
    mean_history = sum(amount[-50:]) / len(amount[-50:])
    if mean_prediction > mean_history:
        insight = "You're likely to exceed your budget in the next month!"
    else:
        insight = "You're likely within your budget in the next month!"

    return {
        "account_no": account_no,
        "date": dates[-50:],
        "historical": amount[-50:],
        "prediction": prediction,
        "insight": insight,
    }

@app.get("/credit_card_analysis/{account_no}")
def credit_card_analysis(account_no: str):
    """Recommend the best credit card based on user spending patterns."""
    transactions, _ = load_transactions()

    # Filter transactions for the given account number
    user_transactions = [t for t in transactions if str(t["account_no"]) == str(account_no)]

    if not user_transactions:
        return {"message": "No transactions found for this account."}
    
    # Get top 3 credit card recommendations
    recommended_cards = generate_card_recommendation(user_transactions)

    return {
        "account_no": account_no,
        "recommended_cards": recommended_cards  # Should return top 3 card names
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)