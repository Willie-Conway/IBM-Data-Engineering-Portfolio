"""
End-to-End Data Engineering Project Script
Covers:
- Data Architecture Design
- Data Warehouse & Schema Design
- Infrastructure Requirements
- ETL Pipeline Integration
- Querying Databases
- Data Analysis & Mining
"""

import pandas as pd
import sqlite3
from mlxtend.frequent_patterns import apriori, association_rules
import os

### 1. Infrastructure Setup (Simulated)
print("✅ Step 1: Infrastructure Setup (Simulated)")
os.makedirs("data_warehouse", exist_ok=True)
db_path = "data_warehouse/retail_dw.db"
print(f"✔️ Data warehouse directory created at: {db_path}\n")

### 2. Data Architecture Design (CSV source → SQLite → Pandas/Data Mining)
print("✅ Step 2: Data Architecture Design")
url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m3/data/Project_data.csv"
raw_df = pd.read_csv(url)
print("✔️ Data Source Loaded from URL\n")

### 3. Schema Design (Star schema simulation)
print("✅ Step 3: Data Warehouse Schema Design")
# Simulate a fact table: Purchase Transactions
# Simulate dimension tables: Customer, Product, Country
raw_df = raw_df.dropna(subset=['CustomerID'])
raw_df = raw_df[~raw_df['InvoiceNo'].str.startswith('C')]
raw_df = raw_df[~raw_df['StockCode'].isin(['M', 'D', 'C2', 'POST'])]

conn = sqlite3.connect(db_path)

# Fact Table
raw_df.to_sql("Fact_Purchase", conn, if_exists="replace", index=False)

# Dimension: Customer
raw_df[['CustomerID', 'Country']].drop_duplicates().to_sql("Dim_Customer", conn, if_exists="replace", index=False)

# Dimension: Product
raw_df[['StockCode', 'Description']].drop_duplicates().to_sql("Dim_Product", conn, if_exists="replace", index=False)

print("✔️ Star schema tables created in SQLite warehouse\n")

### 4. ETL Pipeline Integration
print("✅ Step 4: ETL Pipeline Execution")
def etl_clean_transform(conn):
    df = pd.read_sql("SELECT * FROM Fact_Purchase", conn)
    df['InvoiceDate'] = pd.to_datetime(df['InvoiceDate'])
    df['TotalPrice'] = df['Quantity'] * df['UnitPrice']
    return df

etl_df = etl_clean_transform(conn)
etl_df.to_sql("Fact_Purchase_Transformed", conn, if_exists="replace", index=False)
print("✔️ ETL completed and stored in transformed table\n")

### 5. Querying the Data Warehouse
print("✅ Step 5: Querying Database")
query = """
SELECT Country, SUM(TotalPrice) as Revenue
FROM Fact_Purchase_Transformed
GROUP BY Country
ORDER BY Revenue DESC
LIMIT 5
"""
revenue_df = pd.read_sql(query, conn)
print("✔️ Top 5 countries by revenue:")
print(revenue_df, "\n")

### 6. Data Analysis & Mining (Apriori)
print("✅ Step 6: Market Basket Analysis (Apriori)")
basket_df = pd.read_sql("""
SELECT InvoiceNo, Description, SUM(Quantity) as Quantity
FROM Fact_Purchase
GROUP BY InvoiceNo, Description
""", conn)

basket = basket_df.pivot(index='InvoiceNo', columns='Description', values='Quantity').fillna(0)
basket_encoded = basket.applymap(lambda x: 1 if x > 0 else 0)

frequent_itemsets = apriori(basket_encoded, min_support=0.05, use_colnames=True)
rules = association_rules(frequent_itemsets, metric="confidence", min_threshold=0.6)

print("✔️ Top Association Rules:")
print(rules[['antecedents', 'consequents', 'support', 'confidence', 'lift']].sort_values(by='confidence', ascending=False).head(), "\n")

### 7. Close Connection
conn.close()
print("✅ All steps completed. SQLite connection closed.")
