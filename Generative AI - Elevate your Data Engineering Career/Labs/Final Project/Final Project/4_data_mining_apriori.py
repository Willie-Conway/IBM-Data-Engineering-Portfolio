import sqlite3
import pandas as pd
from mlxtend.frequent_patterns import apriori, association_rules

conn = sqlite3.connect("RetailDW.db")

# Group data for Apriori
query = """
SELECT InvoiceNo, Description, SUM(Quantity) as TotalQuantity
FROM Purchase_Transactions
GROUP BY InvoiceNo, Description
"""
df = pd.read_sql_query(query, conn)
basket = df.pivot(index='InvoiceNo', columns='Description', values='TotalQuantity').fillna(0)
basket_encoded = basket.applymap(lambda x: 1 if x > 0 else 0)

# Run Apriori
frequent_items = apriori(basket_encoded, min_support=0.05, use_colnames=True)
rules = association_rules(frequent_items, metric="confidence", min_threshold=0.7)
rules = rules.sort_values(by="confidence", ascending=False)

print("📈 Association Rules:")
print(rules[['antecedents', 'consequents', 'support', 'confidence', 'lift']].head())

conn.close()
