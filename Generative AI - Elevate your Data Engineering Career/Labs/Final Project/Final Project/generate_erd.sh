#!/bin/bash

# Script: generate_erd.sh
# Purpose: Generate ERD DSL file for visualization on dbdiagram.io

echo "Generating ERD DSL..."

cat <<EOF > retail_schema.dbml
Table Customer {
  CustomerID int [pk]
  CustomerName varchar
  Address varchar
  Phone varchar
  Email varchar
}

Table Inventory {
  StockCode int [pk]
  Description varchar
  QuantityAvailable int
  Price decimal
}

Table TransactionInvoice {
  InvoiceNo int [pk]
  StockCode int [ref: > Inventory.StockCode]
  Quantity int
  InvoiceDate date
  UnitPrice decimal
  CustomerID int [ref: > Customer.CustomerID]
  Country varchar
}
EOF

echo "ERD file written to retail_schema.dbml. Upload to https://dbdiagram.io to visualize."
