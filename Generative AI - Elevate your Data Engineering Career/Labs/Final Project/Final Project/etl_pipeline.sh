#!/bin/bash

# Script: etl_pipeline.sh
# Purpose: Simulate ETL (Extract, Transform, Load) workflow

echo "Starting ETL Process..."

echo "[Extract] Simulating data extraction from CSV"
cp raw_data/online_retail.csv staging/retail_data.csv

echo "[Transform] Cleaning data..."
# Example transformation
sed -i '/,,/d' staging/retail_data.csv  # Remove empty rows

echo "[Load] Loading into SQLite..."
sqlite3 retail.db <<EOF
.read create_schema.sql
.mode csv
.import staging/retail_data.csv TransactionInvoice
EOF

echo "ETL process complete."
