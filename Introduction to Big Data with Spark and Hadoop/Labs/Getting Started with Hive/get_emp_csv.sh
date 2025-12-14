#!/bin/bash
# Script to create a data directory and download emp.csv

DATA_DIR="/home/project/data"
CSV_URL="https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-BD0225EN-SkillsNetwork/data/emp.csv"
CSV_FILE="$DATA_DIR/emp.csv"

echo "🔧 Creating data directory (if needed): $DATA_DIR"
mkdir -p "$DATA_DIR"

echo "📂 Changing to $DATA_DIR"
cd "$DATA_DIR" || { echo "❌ Could not change to $DATA_DIR"; exit 1; }

echo "⬇️  Downloading emp.csv …"
wget -q "$CSV_URL" -O "$CSV_FILE"

if [[ -f "$CSV_FILE" ]]; then
    echo "✅ Download complete: $CSV_FILE"
    echo "🖥️  Preview of downloaded file:"
    head -n 5 "$CSV_FILE"
else
    echo "❌ Download failed!"
    exit 1
fi





# How to use:

# Save the script above to a file, e.g.

# nano get_emp_csv.sh
# (paste the code, then save & exit).

# Make it executable:

# chmod +x get_emp_csv.sh

# Run it:

# ./get_emp_csv.sh