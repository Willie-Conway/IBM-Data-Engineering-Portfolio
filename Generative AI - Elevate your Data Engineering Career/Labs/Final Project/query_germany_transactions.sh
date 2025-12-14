#!/bin/bash

# Check for python and pip
command -v python >/dev/null 2>&1 || { echo >&2 "Python is not installed. Aborting."; exit 1; }
command -v pip >/dev/null 2>&1 || { echo >&2 "pip is not installed. Aborting."; exit 1; }

# Create and activate venv (Windows path for activate)
python -m venv venv
source venv/Scripts/activate

# Install required packages
pip install pandas > /dev/null 2>&1

# Run python inline script
python << EOF
import pandas as pd
import sqlite3

url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m3/data/Project_data.csv"
print("Downloading data...")
data = pd.read_csv(url)

print("Cleaning data...")
initial_len = len(data)
data = data[~data['InvoiceNo'].astype(str).str.startswith('C')]
data = data[~data['StockCode'].isin(['M', 'D', 'C2', 'POST'])]
data = data.dropna(subset=['CustomerID'])
print(f"Entries removed: {initial_len - len(data)}")

print("Saving to SQLite database...")
conn = sqlite3.connect("Invoice_Records.db")
data.to_sql('Purchase_transactions', conn, if_exists='replace', index=False)

print("Querying records for Germany...")
query = "SELECT * FROM Purchase_transactions WHERE Country = 'Germany'"
germany_df = pd.read_sql(query, conn)

germany_df.to_csv("germany_transactions.csv", index=False)
print(f"Germany transactions saved to germany_transactions.csv (total rows: {len(germany_df)})")

conn.close()
EOF

echo "✅ Script completed successfully."



# chmod +x query_germany_transactions.sh
# ./query_germany_transactions.sh