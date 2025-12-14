import sqlite3
import pandas as pd

conn = sqlite3.connect("RetailDW.db")

# Example Queries
q1 = pd.read_sql_query("SELECT COUNT(*) FROM Purchase_Transactions", conn)
q2 = pd.read_sql_query("SELECT * FROM Purchase_Transactions LIMIT 5", conn)
q3 = pd.read_sql_query("SELECT * FROM Purchase_Transactions WHERE Country = 'Germany'", conn)

print("📊 Total Records:", q1.iloc[0, 0])
print("\n📝 Sample Records:")
print(q2)
print("\n🇩🇪 Germany Sample:")
print(q3.head())

conn.close()
