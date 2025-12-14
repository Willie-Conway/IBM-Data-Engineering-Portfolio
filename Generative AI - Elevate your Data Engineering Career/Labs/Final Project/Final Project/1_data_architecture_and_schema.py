import sqlite3

# Create and connect to SQLite database
conn = sqlite3.connect("RetailDW.db")
cursor = conn.cursor()

# Drop tables if they exist
cursor.execute("DROP TABLE IF EXISTS Purchase_Transactions")

# Create table for transactions
cursor.execute("""
CREATE TABLE Purchase_Transactions (
    InvoiceNo TEXT,
    StockCode TEXT,
    Description TEXT,
    Quantity INTEGER,
    InvoiceDate TEXT,
    UnitPrice REAL,
    CustomerID TEXT,
    Country TEXT
)
""")

conn.commit()
print("✅ Data architecture and schema created.")
conn.close()
