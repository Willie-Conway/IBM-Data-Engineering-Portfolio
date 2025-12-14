#!/usr/bin/env bash
# -------------------------------------------------------------
# monitor_spark_job.sh
#
# Monitors Apache Spark Pi job on Kubernetes.
# Automatically detects driver pod and prints:
#   1. Job execution time
#   2. Computed Pi value
#
# Usage:
#   ./monitor_spark_job.sh [namespace]
#   If namespace is omitted, defaults to "default".
# -------------------------------------------------------------

set -euo pipefail

NAMESPACE="${1:-sn-labs-hirewillieco}"  # default to your namespace

echo "🔍 Looking for driver pod in namespace: $NAMESPACE..."

# Since the pod is named 'spark', use it directly
DRIVER_POD="spark"

# Check if the pod exists and is in the namespace
kubectl get pod "$DRIVER_POD" -n "$NAMESPACE" >/dev/null 2>&1 || {
  echo "❌ Pod $DRIVER_POD not found in namespace $NAMESPACE."
  exit 1
}

echo "📦 Driver pod found: $DRIVER_POD"

echo "⏳ Waiting for driver pod to be Running or Succeeded..."
while true; do
  STATUS=$(kubectl get pod "$DRIVER_POD" -n "$NAMESPACE" -o jsonpath='{.status.phase}')
  if [[ "$STATUS" == "Running" || "$STATUS" == "Succeeded" ]]; then
    break
  fi
  sleep 2
done

echo "📈 Fetching Spark job metrics from pod logs..."
# Since there are two containers, specify the spark container explicitly
kubectl logs "$DRIVER_POD" -c spark -n "$NAMESPACE" | grep "Job 0 finished: reduce at SparkPi.scala" || echo "No job completion log found yet."
kubectl logs "$DRIVER_POD" -c spark -n "$NAMESPACE" | grep "Pi is roughly" || echo "No Pi result log found yet."







# How to Use:

# Save it:

# nano monitor_spark_job.sh

# Paste the script, then:

# chmod +x monitor_spark_job.sh

# Run it:

# ./monitor_spark_job.sh sn-labs-hirewillieco