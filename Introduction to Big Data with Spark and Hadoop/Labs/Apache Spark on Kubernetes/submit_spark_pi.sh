#!/bin/bash

# Configurable parameters
SPARK_POD_NAME="spark"                 # Name of the Spark pod running in Kubernetes
NAMESPACE="${my_namespace:-default}"  # Kubernetes namespace; defaults to 'default' if not set
JOB_NAME="spark-pi-experiment"        # Name prefix for Spark job
EXECUTOR_INSTANCES=1                   # Number of executor pods
EXECUTOR_CORES_REQUEST=0.2             # Executor CPU request
EXECUTOR_CORES_LIMIT=0.3               # Executor CPU limit
DRIVER_CORES_REQUEST=0.2               # Driver CPU request
DRIVER_CORES_LIMIT=0.3                 # Driver CPU limit
DRIVER_MEMORY="512m"                   # Driver memory
SPARK_IMAGE="romeokienzler/spark-py:3.1.2"  # Spark image with Kubernetes support
ITERATIONS=10                         # Number of iterations for Pi calculation

echo "Submitting SparkPi job with the following parameters:"
echo "Job Name: $JOB_NAME"
echo "Executor Instances: $EXECUTOR_INSTANCES"
echo "Executor CPU: request=$EXECUTOR_CORES_REQUEST, limit=$EXECUTOR_CORES_LIMIT"
echo "Driver CPU: request=$DRIVER_CORES_REQUEST, limit=$DRIVER_CORES_LIMIT"
echo "Driver Memory: $DRIVER_MEMORY"
echo "Iterations: $ITERATIONS"
echo "Namespace: $NAMESPACE"
echo ""

kubectl exec "$SPARK_POD_NAME" -c spark -- ./bin/spark-submit \
--master k8s://http://127.0.0.1:8001 \
--deploy-mode cluster \
--name "$JOB_NAME" \
--class org.apache.spark.examples.SparkPi \
--conf spark.executor.instances="$EXECUTOR_INSTANCES" \
--conf spark.kubernetes.container.image="$SPARK_IMAGE" \
--conf spark.kubernetes.executor.request.cores="$EXECUTOR_CORES_REQUEST" \
--conf spark.kubernetes.executor.limit.cores="$EXECUTOR_CORES_LIMIT" \
--conf spark.kubernetes.driver.request.cores="$DRIVER_CORES_REQUEST" \
--conf spark.kubernetes.driver.limit.cores="$DRIVER_CORES_LIMIT" \
--conf spark.driver.memory="$DRIVER_MEMORY" \
--conf spark.kubernetes.namespace="$NAMESPACE" \
local:///opt/spark/examples/jars/spark-examples_2.12-3.1.2.jar \
"$ITERATIONS"




# How to use:

# Save this as submit_spark_pi.sh

# Make it executable:

# chmod +x submit_spark_pi.sh

# Run it:

# ./submit_spark_pi.sh
