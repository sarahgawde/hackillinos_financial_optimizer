from transformers import T5ForConditionalGeneration, T5Tokenizer
import pandas as pd
import os

# def load_credit_cards():
#     """Load credit card details from a CSV file and only consider the 'desc-text' column."""
#     credit_cards = pd.read_csv('../data/creditcard_list.csv')  # Adjust the path as needed
#     credit_cards['desc-text'] = credit_cards['desc-text'].apply(str)  # Ensure the desc-text is in string format
#     return credit_cards[['desc-text']]  # Only return the 'desc-text' column

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
    amounts = [txn["amount"] for txn in transactions]  # Extract amounts as a list
    # print(transactions)
    return transactions, amounts

def create_prompt(transactions):
    """Generate a prompt for the LLM based on transactions, predicted spending, and card descriptions."""
    
    # Convert the transactions to a string format that T5 can understand
    transaction_str = "\n".join([f"Category: {t['category']}, Amount: {t['amount']}, Date: {t['date']}" for t in transactions])
    
    # Example of predicting the spending
    # prediction_str = f"Prediction: {prediction}"
    
    # Now, generate the prompt for the T5 model. 
    # The model will process this input and generate the recommendation.
    prompt = f"Given the following user transactions:\n{transaction_str}\n Categorize the each transaction based on it's TRANSACTION DETAILS column, categorize it is broadly 5 categories: Bussiness, Travel, Food, Shopping and Others\n\n. Give the output in following format: \nCategory: <category>, Total Amount in that category: <amount>\n"

    return prompt

# Function to generate the recommendation using the T5 model
def generate_card_recommendation(transactions):
    
    # Initialize T5 model and tokenizer
    model_name = 't5-small'  # You can use t5-base or other variants depending on your needs
    tokenizer = T5Tokenizer.from_pretrained(model_name)
    model = T5ForConditionalGeneration.from_pretrained(model_name)

    # Load the credit card descriptions (only 'desc-text')
    # credit_cards = load_credit_cards()

    
    # Create the prompt for the model
    prompt = create_prompt(transactions)
    # print("###############")
    # print(prompt)
    # print("###############")

    # Tokenize the prompt
    input_ids = tokenizer.encode(prompt, return_tensors="pt", truncation=True, max_length=512)

    try:
        # Get the model prediction
        output = model.generate(input_ids, max_length=150, num_beams=5, no_repeat_ngram_size=2, early_stopping=True)
        decoded_output = tokenizer.decode(output[0], skip_special_tokens=True)
        
        # Debug: Print the model's output
        print("Debug: LLM Model Output:", decoded_output)

        # Assuming the output contains the best card recommendation
        best_card = decoded_output.strip()
        print(best_card)
        return best_card

    except Exception as e:
        # Debug: Print any error
        print("Error occurred during LLM inference:", e)
        return None
    
transactions, _ = load_transactions()

# Filter transactions for the given account number
user_transactions = [t for t in transactions if str(t["account_no"]) == "account_no"]

if not user_transactions:
    print("No transactions")

# Get top 3 credit card recommendations
recommended_cards = generate_card_recommendation(user_transactions)


    
    # # Generate the output using the model
    # with torch.no_grad():
    #     outputs = model.generate(
    #         inputs["input_ids"], 
    #         max_length=150, 
    #         num_beams=5, 
    #         no_repeat_ngram_size=2, 
    #         early_stopping=True
    #     )
    
    # # Decode the output and return the recommendation
    # recommendation = tokenizer.decode(outputs[0], skip_special_tokens=True)
    # return recommendation


# import pandas as pd
# from google.cloud import aiplatform

# def load_credit_cards():
#     """Load credit card details from a CSV file."""
#     credit_cards = pd.read_csv('creditcard_list.csv')
#     credit_cards['desc-text'] = credit_cards['desc-text'].apply(str) 
#     return credit_cards

# def prepare_input_data(user_transactions, predicted_spending, credit_cards, user_preferences=None):
#     """
#     Prepare the input data for Gemini AI.
#     """
#     transaction_data = "\n".join([f"Category: {t['category']}, Amount: {t['amount']}, Date: {t['date']}" for t in user_transactions])
#     prediction_data = "\n".join([f"Predicted spending for {i+1} month: {amount}" for i, amount in enumerate(predicted_spending)])

#     card_data = "\n".join([f"Card: {card['card_name']}, Benefits: {card['benefits']}, Fees: {card['fees']}" for _, card in credit_cards.iterrows()])

#     # Combine all data into a single input string for Gemini
#     input_data = f"""
#     User Transactions:
#     {transaction_data}

#     Predicted Spending:
#     {prediction_data}

#     Available Credit Cards:
#     {card_data}
#     """

#     # Optionally, add user preferences if available
#     if user_preferences:
#         input_data += f"\nUser Preferences: {user_preferences}"

#     return input_data

# def get_best_credit_card(transactions, prediction, user_credit_score=None, user_preferences=None):
#     # Set your project and region (adjust if necessary)
#     project = 'your-project-id'
#     location = 'us-central1'

#     credit_cards = load_credit_cards()
#     input_data = prepare_input_data(transactions, prediction, credit_cards)

#     # Initialize the AI Platform client
#     aiplatform.init(project=project, location=location)

#     # Prepare the endpoint and model
#     endpoint = aiplatform.Endpoint(endpoint_name="projects/{}/locations/{}/endpoints/{}/models/{}".format(project, location, "your-endpoint-id", "your-model-id"))

#     # Call Gemini AI to get the recommendation
#     response = endpoint.predict(instances=[{'input': input_data}])

#     # Extract the recommendation from the response
#     recommendation = response.predictions[0]
    
#     return recommendation

# # def get_best_credit_card(transactions, prediction):
# #     """
# #     This function uses the LLM model or some rules-based logic to determine the best credit card.
# #     """
# #     # Example of the model's logic (simplified)
# #     total_spent = sum([t['amount'] for t in transactions])
# #     predicted_spending = sum(prediction)  # Example of summing the predicted spending

# #     # Based on total spending and predicted trends, select the best card
# #     if total_spent > 1000:
# #         return "Chase Sapphire Preferred"  # Best for dining and travel
# #     elif predicted_spending > 500:
# #         return "Amex Blue Cash"  # Best for cash back in categories like groceries
# #     else:
# #         return "Capital One Venture"  # Best for flexible travel rewards