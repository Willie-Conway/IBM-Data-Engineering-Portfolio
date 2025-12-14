import pandas as pd
import sqlite3

# Step 1: Read CSV data from URL
url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m3/data/Project_data.csv"
df = pd.read_csv(url)

# Step 2: Print initial record count
initial_count = len(df)
print(f"[INFO] Initial record count: {initial_count}")

# Step 3: Clean the data
df = df[~df['InvoiceNo'].astype(str).str.startswith('C')]  # Remove credit notes
df = df[~df['StockCode'].isin(['M', 'D', 'C2', 'POST'])]    # Remove irrelevant stock codes
df = df.dropna(subset=['CustomerID'])                      # Remove missing customer IDs

# Step 4: Print final record count
final_count = len(df)
print(f"[INFO] Final record count: {final_count}")
print(f"[INFO] Records removed: {initial_count - final_count}")

# Step 5: Load into SQLite
conn = sqlite3.connect('Invoice_Records.db')
df.to_sql('Purchase_transactions', conn, if_exists='replace', index=False)

# Step 6: Sample query
sample_query = pd.read_sql_query("SELECT * FROM Purchase_transactions LIMIT 5;", conn)
print("[INFO] Sample of loaded data:")
print(sample_query)

# Step 7: Close connection
conn.close()
