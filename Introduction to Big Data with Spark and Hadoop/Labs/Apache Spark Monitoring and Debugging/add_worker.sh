#!/bin/bash

set -e

echo "🔍 Checking if spark-worker-2 already exists..."
if docker ps -a --format '{{.Names}}' | grep -q '^spark-worker-2$'; then
  echo "⚠️ spark-worker-2 already exists. Starting container..."
  docker start spark-worker-2
else
  echo "🚀 Starting spark-worker-2 container..."
  docker run \
    --name spark-worker-2 \
    --link spark-master:spark-master \
    -e ENABLE_INIT_DAEMON=false \
    -p 8082:8082 \
    -d bde2020/spark-worker:3.1.1-hadoop3.2
fi

echo "✅ spark-worker-2 is running."




# Make it executable and run it:

# chmod +x add_worker.sh

# ./add_worker.sh