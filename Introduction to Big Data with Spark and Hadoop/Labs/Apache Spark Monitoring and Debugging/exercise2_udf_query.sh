#!/usr/bin/env bash
###############################################################################
# Exercise 2 : Run an SQL Query and Debug in the Spark Application UI
###############################################################################
set -e

echo "🔍  Locating Spark‑Master container …"
MASTER_ID=$(docker ps --filter "name=spark-master" --format "{{.ID}}")
if [[ -z $MASTER_ID ]]; then
  echo "❌  Spark‑Master container not found. Start the cluster first." ; exit 1
fi
echo "✅  Spark‑Master container ID: $MASTER_ID"
echo

###############################################################################
# 1) BUGGY JOB  – reproduce the failure
###############################################################################
cat > /tmp/udf_buggy.py <<'PY_BUG'
from pyspark.sql import SparkSession
from pyspark.sql.functions import udf
import time, sys

spark = SparkSession.builder.getOrCreate()
df = spark.read.csv("/home/root/cars.csv", header=True, inferSchema=True) \
       .repartition(32).cache()

@udf("string")
def engine(c):
    time.sleep(0.2)              # Make the stage easy to spot
    return {6: "V6", 8: "V8"}[c] # KeyError for any other cylinder count

df = df.withColumn("engine", engine("cylinders"))
df.groupby("cylinders").agg({"mpg": "avg", "engine": "first"}).show()
PY_BUG

echo "🚀  Submitting BUGGY job (this will fail on purpose)…"
docker cp /tmp/udf_buggy.py "$MASTER_ID":/tmp/
docker exec -it "$MASTER_ID" /spark/bin/spark-submit /tmp/udf_buggy.py || true

echo
echo "❗  The job above *should have failed*."
echo "📊  Open the Spark Application UI (Skills Network → OTHER → Launch Application → port 4040)."
echo "    In *Jobs* → failed job → failed stage, expand a task to see the KeyError."
echo
read -p "🔎  After diagnosing the failure, press <Enter> to run the FIXED job…"

###############################################################################
# 2) FIXED JOB  – graceful UDF
###############################################################################
cat > /tmp/udf_fixed.py <<'PY_FIX'
from pyspark.sql import SparkSession
from pyspark.sql.functions import udf
import time

spark = SparkSession.builder.getOrCreate()
df = spark.read.csv("/home/root/cars.csv", header=True, inferSchema=True) \
       .repartition(32).cache()

@udf("string")
def engine(c):
    time.sleep(0.1)
    return {4: "inline-four", 6: "V6", 8: "V8"}.get(c, "other")

df = df.withColumn("engine", engine("cylinders"))
df.groupby("cylinders").agg({"mpg": "avg", "engine": "first"}).show(truncate=False)
PY_FIX

echo "🔧  Submitting FIXED job…"
docker cp /tmp/udf_fixed.py "$MASTER_ID":/tmp/
docker exec -it "$MASTER_ID" /spark/bin/spark-submit /tmp/udf_fixed.py

echo
echo "✅  FIXED job completed successfully!"
echo "📈  Refresh the UI (port 4040) to see the new job marked *Succeeded*."
echo "🎉  All done — feel free to experiment further!"




# How to run

# chmod +x exercise2_udf_query.sh

# ./exercise2_udf_query.sh