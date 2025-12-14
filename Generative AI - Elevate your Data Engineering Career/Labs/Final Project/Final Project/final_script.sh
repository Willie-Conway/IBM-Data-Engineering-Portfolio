import pandas as pd
import sqlite3
from mlxtend.frequent_patterns import apriori, association_rules

# Step 1: Load data
url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m3/data/Project_data.csv"
data = pd.read_csv(url)

# Step 2: Clean data
initial_len = len(data)
data = data[~data['InvoiceNo'].astype(str).str.startswith('C')]
data = data[~data['StockCode'].isin(['M', 'D', 'C2', 'POST'])]
data = data.dropna(subset=['CustomerID'])

# Step 3: Save to SQLite
conn = sqlite3.connect('Invoice_Records.db')
data.to_sql('Purchase_transactions', conn, if_exists='replace', index=False)

# Step 4: Extract Germany transactions (optional, not used in mining here)
germany_df = pd.read_sql("SELECT * FROM Purchase_transactions WHERE Country = 'Germany'", conn)
germany_df.to_csv("germany_transactions.csv", index=False)

# Step 5: Prepare data for Apriori mining
query = """
SELECT InvoiceNo, Description, SUM(Quantity) AS TotalQuantity
FROM Purchase_transactions
GROUP BY InvoiceNo, Description
"""
df_grouped = pd.read_sql(query, conn)

# Pivot and encode
df_pivot = df_grouped.pivot(index='InvoiceNo', columns='Description', values='TotalQuantity').fillna(0)
df_encoded = df_pivot.applymap(lambda x: 1 if x > 0 else 0)

# Step 6: Run Apriori and extract rules
frequent_itemsets = apriori(df_encoded, min_support=0.05, use_colnames=True)
rules = association_rules(frequent_itemsets, metric="confidence", min_threshold=0.7)

# Step 7: Sort and display rules
rules = rules.sort_values(by='confidence', ascending=False)
print("\n🧠 Association Rules (top):")
print(rules[['antecedents', 'consequents', 'confidence']].head(10))

# Optionally save
rules.to_csv("association_rules.csv", index=False)

conn.close()
