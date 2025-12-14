#!/bin/bash

echo "🔻 Stopping any running Docker containers..."
for i in $(docker ps | awk '{print $1}' | grep -v CONTAINER); do
  docker kill $i
done

echo "🧹 Removing old Spark containers (ignore 'No such container' errors)..."
docker rm spark-master spark-worker-1 spark-worker-2

echo "🚀 Starting Spark Master container..."
docker run \
    --name spark-master \
    -h spark-master \
    -e ENABLE_INIT_DAEMON=false \
    -p 4040:4040 \
    -p 8080:8080 \
    -v $(pwd):/home/root \
    -d bde2020/spark-master:3.1.1-hadoop3.2

echo "✅ Spark Master started at http://localhost:8080"

echo "🔧 Starting Spark Worker container..."
docker run \
    --name spark-worker-1 \
    --link spark-master:spark-master \
    -e ENABLE_INIT_DAEMON=false \
    -p 8081:8081 \
    -v $(pwd):/home/root \
    -d bde2020/spark-worker:3.1.1-hadoop3.2

echo "✅ Spark Worker connected to Spark Master"

echo "🌐 Web UIs:"
echo "- Spark Master UI: http://localhost:8080"
echo "- Spark Worker UI: http://localhost:8081"


# How to Use:

# Save this script as init_spark_cluster.sh

# Make it executable and run:

# chmod +x init_spark_cluster.sh

# ./init_spark_cluster.sh