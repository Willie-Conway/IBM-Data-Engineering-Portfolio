#!/usr/bin/env bash
# -------------------------------------------------------------
# submit_spark_job.sh
#
# Submits a Spark application to the Kubernetes cluster by
# executing spark‑submit inside the existing 'spark' pod.
#
# • Accepts optional CLI args:
#     ./submit_spark_job.sh <iterations> <namespace>
# • Falls back to defaults if args are omitted.
#
# -------------------------------------------------------------

# ---------- Configurable defaults ----------
ITERATIONS="${1:-10}"                    # default Pi iterations
K8S_NS="${2:-$my_namespace}"             # default namespace env var
IMAGE="romeokienzler/spark-py:3.1.2"     # Spark + kubectl image
MASTER_URL="k8s://http://127.0.0.1:8001" # local kube‑proxy URL
APP_NAME="spark-pi"
CLASS_NAME="org.apache.spark.examples.SparkPi"
JAR_PATH="local:///opt/spark/examples/jars/spark-examples_2.12-3.1.2.jar"

# ---------- Submission ----------
echo "🚀 Submitting SparkPi job to namespace: $K8S_NS"
echo "   • Iterations  : $ITERATIONS"
echo "   • Docker image: $IMAGE"
echo "   • Master URL  : $MASTER_URL"
echo "---------------------------------------------"

kubectl exec spark -c spark -- ./bin/spark-submit \
  --master "${MASTER_URL}" \
  --deploy-mode cluster \
  --name "${APP_NAME}" \
  --class "${CLASS_NAME}" \
  --conf spark.executor.instances=1 \
  --conf spark.kubernetes.container.image="${IMAGE}" \
  --conf spark.kubernetes.executor.request.cores=0.2 \
  --conf spark.kubernetes.executor.limit.cores=0.3 \
  --conf spark.kubernetes.driver.request.cores=0.2 \
  --conf spark.kubernetes.driver.limit.cores=0.3 \
  --conf spark.driver.memory=512m \
  --conf spark.kubernetes.namespace="${K8S_NS}" \
  "${JAR_PATH}" \
  "${ITERATIONS}"

echo "✅ spark-submit command executed."
echo "🔍 Follow driver logs with:"
echo "    kubectl logs -l spark-role=driver --tail=100 --follow"

# How to use

# # 1. Make the script executable
# chmod +x submit_spark_job.sh

# # 2. Run with defaults (10 iterations, uses $my_namespace)
# ./submit_spark_job.sh

# # 3. Run with custom iterations and namespace
# ./submit_spark_job.sh 20 my-custom-ns

# The script:
# 1. Executes spark-submit inside the running spark container.
# 2. Uses the local kube‑proxy address (127.0.0.1:8001) for the Kubernetes API server.
# 3. Sets reasonable CPU and memory limits for both driver and executor.
# 4. Allows you to override iteration count and namespace via CLI arguments.

# After it finishes submitting, tail the driver logs to watch progress:
# kubectl logs -l spark-role=driver --follow
