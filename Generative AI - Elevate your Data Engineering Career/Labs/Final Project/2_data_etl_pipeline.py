import pandas as pd
import sqlite3

# Load raw data
url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m3/data/Project_data.csv"
df = pd.read_csv(url)

# Basic Cleaning
df = df[~df['InvoiceNo'].str.startswith('C')]
df = df[~df['StockCode'].isin(['M', 'D', 'C2', 'POST'])]
df = df.dropna(subset=['CustomerID'])

# Load into SQLite
conn = sqlite3.connect("RetailDW.db")
df.to_sql("Purchase_Transactions", conn, if_exists="replace", index=False)
conn.commit()
print("✅ ETL pipeline executed and data loaded.")
conn.close()
