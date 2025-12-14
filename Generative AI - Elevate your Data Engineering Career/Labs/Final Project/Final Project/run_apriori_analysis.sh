#!/bin/bash

# Run complete ETL + Apriori pipeline
echo "🚀 Starting Apriori Association Rule Mining Pipeline..."

# Activate virtual env if exists
source venv/bin/activate 2>/dev/null

# Ensure dependencies are installed
pip install pandas mlxtend

# Execute main pipeline
python3 << EOF
$(cat << 'END_HEREDOC'
# [Paste the Python script from above here if embedding inside .sh]
END_HEREDOC
)
EOF

echo "✅ Done. Results saved to association_rules.csv and germany_transactions.csv."
