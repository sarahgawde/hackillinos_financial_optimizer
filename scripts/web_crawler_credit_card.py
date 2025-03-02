import requests
import pandas as pd
from bs4 import BeautifulSoup

# URL of the credit card listing page
url = "https://www.cardratings.com/credit-card-list.html"

# Send a request to fetch the page content
headers = {"User-Agent": "Mozilla/5.0"}  # To mimic a real browser request
response = requests.get(url, headers=headers)
soup = BeautifulSoup(response.text, "html.parser")

# Locate the table containing credit card details (adjust selector as needed)
table = soup.find("table")

# Extract table headers
headers = [th.text.strip() for th in table.find_all("th")]

# Extract table rows
data = []
for row in table.find_all("tr")[1:]:  # Skipping the header row
    cols = row.find_all("td")
    data.append([col.text.strip() for col in cols])

# Convert to DataFrame
df = pd.DataFrame(data, columns=headers)

# Save to CSV or Database
df.to_csv("output/credit_cards.csv", index=False)

print("Credit card data saved successfully!")