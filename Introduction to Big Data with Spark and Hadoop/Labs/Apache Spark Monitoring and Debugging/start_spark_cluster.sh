#!/bin/bash

# -----------------------------
# Task A: Download Sample Data
# -----------------------------

echo "📥 Downloading sample dataset..."
wget https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-BD0225EN-SkillsNetwork/labs/data/cars.csv

echo "✅ Dataset downloaded: cars.csv"

# -----------------------------
# Task B: Start Spark Master
# -----------------------------

echo "🚀 Starting Spark Master container..."

docker run -d \
  --name spark-master \
  --hostname spark-master \
  -p 8080:8080 \
  -p 7077:7077 \
  bitnami/spark:latest \
  /opt/bitnami/spark/bin/spark-class org.apache.spark.deploy.master.Master

echo "✅ Spark Master started at http://localhost:8080"

# -----------------------------
# Task C: Start Spark Worker
# -----------------------------

echo "🔧 Starting Spark Worker container..."

docker run -d \
  --name spark-worker \
  --hostname spark-worker \
  --link spark-master:spark-master \
  -e SPARK_MODE=worker \
  -e SPARK_MASTER_URL=spark://spark-master:7077 \
  -p 8081:8081 \
  bitnami/spark:latest \
  /opt/bitnami/spark/bin/spark-class org.apache.spark.deploy.worker.Worker spark://spark-master:7077

echo "✅ Spark Worker started and connected to Master"

# -----------------------------
# Task D: Launch PySpark Shell
# -----------------------------

echo "💻 Launching PySpark shell connected to Spark Standalone Cluster..."

docker run -it --rm \
  --name pyspark-client \
  --link spark-master:spark-master \
  -v $(pwd):/data \
  bitnami/spark:latest \
  /opt/bitnami/spark/bin/pyspark --master spark://spark-master:7077

# -----------------------------
# Notes
# -----------------------------
# Spark Master UI: http://localhost:8080
# Spark Worker UI: http://localhost:8081
# You can check logs with:
# docker logs spark-master
# docker logs spark-worker
# To stop containers: docker stop spark-master spark-worker && docker rm spark-master spark-worker


# How to Use

# Copy & paste this script into a file called start_spark_cluster.sh.

# Run it from the Theia terminal:

# chmod +x start_spark_cluster.sh

# ./start_spark_cluster.sh