#!/bin/bash
# ------------------------------------------------------------
# submit_sparkpi.sh
# Submits the SparkPi job to the running Kubernetes cluster
# from inside the Spark container in the "spark" pod.
# ------------------------------------------------------------

echo "🚀 Submitting SparkPi job to Kubernetes..."

kubectl exec spark -c spark -- ./bin/spark-submit \
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
  --conf spark.kubernetes.namespace=${my_namespace} \
  local:///opt/spark/examples/jars/spark-examples_2.12-3.1.2.jar \
  10

echo "✅ SparkPi submission command completed."
echo "📈 Check logs using: kubectl logs -l spark-role=driver --follow"

# How to use

# 1. Create the script:
# nano submit_sparkpi.sh

# 2. Paste the contents above.

# 3. Make it executable:
# chmod +x submit_sparkpi.sh

# 4. Run it:
# ./submit_sparkpi.sh

# After submission
# Check driver logs with:
# kubectl logs -l spark-role=driver --follow

# You should see output like:
# Pi is roughly 3.14159
