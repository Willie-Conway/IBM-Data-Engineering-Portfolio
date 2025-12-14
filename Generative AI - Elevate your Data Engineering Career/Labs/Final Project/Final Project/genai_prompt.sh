#!/bin/bash

# Script: genai_prompt.sh
# Purpose: Prompt to use GenAI to generate a query

echo "Prompt to use in Generative AI Platform (e.g., ChatGPT, Gemini, etc.):"

cat <<EOF

Propose an optimized SQL query for the following use case:
- Retrieve total revenue by country.
- Include only transactions after January 1, 2024.
- Sort by highest revenue first.

Use the table schema:
- TransactionInvoice(InvoiceNo, StockCode, Quantity, InvoiceDate, UnitPrice, CustomerID, Country)

EOF



# chmod +x *.sh
# ./setup_schema.sh
# ./generate_erd.sh
# ./etl_pipeline.sh
# ./query_warehouse.sh
# ./genai_prompt.sh
