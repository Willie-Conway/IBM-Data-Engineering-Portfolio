#!/bin/bash
###############################################################################
# Task B : Debug & Fix the engine() UDF, then re-run the aggregation query
# ---------------------------------------------------------------------------
# • Locates the running Spark‑Master container.
# • Submits a PySpark job that:
#     – Reloads cars.csv
#     – Defines the **corrected** engine() UDF
#     – Adds the "engine" column, groups, aggregates, and shows results.
###############################################################################

set -e

echo "🔍  Locating Spark‑Master container …"
MASTER_ID=$(docker ps --filter "name=spark-master" --format "{{.ID}}")

if [[ -z "$MASTER_ID" ]]; then
  echo "❌  Spark‑Master container not found. Please start the cluster first."
  exit 1
fi
echo "✅  Spark‑Master container ID: $MASTER_ID"
echo

echo "🚀  Submitting FIXED PySpark job …"
docker exec -i "$MASTER_ID" /spark/bin/spark-submit - <<'PYSPARK_FIX'
from pyspark.sql import SparkSession
from pyspark.sql.functions import udf
import time

spark = SparkSession.builder.getOrCreate()

# ------------------------------------------------------------------
# Load the sample data
# ------------------------------------------------------------------
df = spark.read.csv("/home/root/cars.csv", header=True, inferSchema=True) \
       .repartition(32) \
       .cache()

# ------------------------------------------------------------------
# Corrected UDF: covers 4‑cyl engines and supplies a default value
# ------------------------------------------------------------------
@udf("string")
def engine(cylinders):
    time.sleep(0.2)                 # Small delay for UI visibility
    eng = {4: "inline-four", 6: "V6", 8: "V8"}
    return eng.get(cylinders, "other")

# Recreate the “engine” column and run the aggregation
df = df.withColumn("engine", engine("cylinders"))
dfa = df.groupby("cylinders").agg({"mpg": "avg", "engine": "first"})

# Show final, error‑free results
dfa.show(truncate=False)
PYSPARK_FIX

echo
echo "🎉  Query completed without errors!"
echo "🌐  Refresh the Spark Application UI at http://localhost:4040 to observe the successful job."
echo




# How to run

# chmod +x fix_udf_and_rerun.sh

# ./fix_udf_and_rerun.sh

# When the script finishes you should see output similar to:

# Edit
