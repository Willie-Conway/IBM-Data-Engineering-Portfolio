#!/bin/bash

echo "🔍 Locating Spark Master container..."
MASTER_CONTAINER=$(docker ps | grep spark-master | awk '{print $1}')

if [ -z "$MASTER_CONTAINER" ]; then
    echo "❌ Error: Spark Master container not found. Make sure it's running."
    exit 1
fi

echo "✅ Found Spark Master container: $MASTER_CONTAINER"

echo "🚀 Launching PySpark shell connected to spark://spark-master:7077..."
docker exec -it $MASTER_CONTAINER /spark/bin/pyspark --master spark://spark-master:7077 <<'EOF'
print("📊 Reading and caching cars.csv into DataFrame...")
df = spark.read.csv("/home/root/cars.csv", header=True, inferSchema=True) \
    .repartition(32) \
    .cache()
df.show()
print("✅ DataFrame loaded and cached. Visit http://localhost:4040 to monitor Spark Application UI.")
EOF

echo "🌐 To open the Spark Application UI:"
echo "1. Click the 'Skills Network' button on the left in Theia."
echo "2. Click 'OTHER' > 'Launch Application'."
echo "3. Enter port: 4040 and click Launch."




# To Use This Script:

# Save it as connect_pyspark_and_open_ui.sh

# Make it executable:

# chmod +x connect_pyspark_and_open_ui.sh

# Run it from the Theia terminal:

# ./connect_pyspark_and_open_ui.sh