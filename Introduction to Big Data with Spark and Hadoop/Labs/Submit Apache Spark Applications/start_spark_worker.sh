#!/bin/bash

# === CONFIGURATION ===
MASTER_URL=$1  # Pass this as an argument to the script (e.g., spark://theiadocker-willieconway:7077)
CORES=1
MEMORY=1g

# === ENVIRONMENT SETUP ===
export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
export SPARK_HOME=/home/project/spark-3.3.3-bin-hadoop3

# === START WORKER ===
cd $SPARK_HOME || { echo "❌ SPARK_HOME directory not found."; exit 1; }

if [ -z "$MASTER_URL" ]; then
  echo "❌ Missing Master URL. Usage: ./start_spark_worker.sh spark://theiadocker-hirewillieco:7077"
  exit 1
fi

echo "🚀 Starting Spark Worker..."
echo "🔗 Connecting to Master at: $MASTER_URL"
./sbin/start-worker.sh $MASTER_URL --cores $CORES --memory $MEMORY

echo "✅ Spark Worker should now be running and connected to the Master."
echo "🌐 Visit http://localhost:8080 or your Spark Master UI to confirm."




# How to Use:

# Save the script:

# nano start_spark_worker.sh

# Paste the script above, then save with Ctrl + O, Enter, and exit with Ctrl + X.

# Make it executable:

# chmod +x start_spark_worker.sh

# Run it with your actual master URL (replace yourname with what you saw in the Master UI):

# ./start_spark_worker.sh spark://theiadocker-hirewillieco:7077