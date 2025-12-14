#!/usr/bin/env bash
# -------------------------------------------------------------------
# submit_sparkpi_once.sh
#
# Submits the SparkPi job from inside the running Spark pod container
# to the Kubernetes API using the correct internal spark-submit path.
#
# Usage:
#   ./submit_sparkpi_once.sh <namespace>
# -------------------------------------------------------------------

set -euo pipefail

# Validate input
if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <namespace>"
  exit 1
fi

NAMESPACE="$1"
SPARK_HOME="/spark-3.1.2-bin-hadoop3.2"
SUBMIT="$SPARK_HOME/bin/spark-submit"

echo "🚀 Submitting SparkPi to namespace: $NAMESPACE"

kubectl exec spark -n "$NAMESPACE" -c spark -- $SUBMIT \
  --master k8s://http://127.0.0.1:8001 \
  --deploy-mode cluster \
  --name spark-pi \
  --class org.apache.spark.examples.SparkPi \
  --conf spark.executor.instances=1 \
  --conf spark.kubernetes.container.image=romeokienzler/spark-py:3.1.2 \
  --conf spark.kubernetes.executor.request.cores=0.2 \
  --conf spark.kubernetes.executor.limit.cores=0.3 \
  --conf spark.kubernetes.driver.request.cores=0.2 \
  --conf spark.kubernetes.driver.limit.cores=0.3 \
  --conf spark.driver.memory=512m \
  --conf spark.kubernetes.namespace="$NAMESPACE" \
  local:///opt/spark/examples/jars/spark-examples_2.12-3.1.2.jar \
  10

echo "✅ SparkPi job submitted!"
echo "📈 To monitor logs, run:"
echo "    kubectl logs -l spark-role=driver -n $NAMESPACE --follow --tail=100"




# How to use:

# chmod +x submit_sparkpi_once.sh

# ./submit_sparkpi_once.sh            # uses default namespace

# ./submit_sparkpi_once.sh sn-labs-hirewillieco      # or specify another namespace

# Monitoring:

# kubectl logs -l spark-role=driver -n sn-labs-hirewillieco --follow --tail=100
