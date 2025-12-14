#!/bin/bash

# Script: query_warehouse.sh
# Purpose: Run optimized queries on the data warehouse

echo "Running sales summary query..."

sqlite3 retail.db <<EOF
.headers on
.mode column
SELECT InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
FROM TransactionInvoice
LIMIT 10;
EOF
