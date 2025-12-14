#!/bin/bash
###############################################################################
# Script to copy the PySpark job script into the spark-master container
# and execute it with spark-submit
###############################################################################

set -e

echo "🔍 Locating Spark-Master container..."
MASTER_ID=$(docker ps --filter "name=spark-master" --format "{{.ID}}")

if [[ -z "$MASTER_ID" ]]; then
  echo "❌ Spark-Master container not found. Please start the cluster first."
  exit 1
fi
echo "✅ Found Spark-Master container: $MASTER_ID"
echo

echo "📋 Copying rerun_query.py script into container..."
docker cp rerun_query.py "$MASTER_ID":/rerun_query.py

echo "🚀 Running PySpark job inside the container..."
docker exec -it "$MASTER_ID" /spark/bin/spark-submit /rerun_query.py

echo
echo "🎉 PySpark job completed successfully!"



# Run:

# chmod +x rerun_query.sh

# ./rerun_query.sh