#!/usr/bin/env bash
# ------------------------------------------------------------
# deploy_spark_pod.sh
#  • uses kubectl directly (no alias)
#  • applies spark/pod_spark.yaml
#  • waits until pod is Running (2/2)
#  • retries once on ImagePullBackOff / CrashLoopBackOff
# ------------------------------------------------------------

set -euo pipefail

MANIFEST="fgskh-new_horizons/spark/pod_spark.yaml"
POD_NAME="spark"
RETRY=0
MAX_RETRIES=1              # retry once

spinner() {
  local c=0 chars="/-\|" ; while :; do
    printf "\r${chars:c++%4:1} "
    sleep 0.2
  done
}

apply_pod() {
  echo "🚀 Applying manifest: $MANIFEST"
  kubectl apply -f "$MANIFEST" >/dev/null
}

delete_pod() {
  echo "🗑  Deleting pod $POD_NAME"
  kubectl delete po "$POD_NAME" --ignore-not-found >/dev/null
}

wait_until_ready() {
  echo -n "⏳ Waiting for pod $POD_NAME to reach Running (2/2) "
  spinner & SPIN_PID=$!

  while true; do
    STATUS_LINE=$(kubectl get po "$POD_NAME" --no-headers 2>/dev/null || true)
    READY=$(echo "$STATUS_LINE" | awk '{print $2}')
    STATUS=$(echo "$STATUS_LINE" | awk '{print $3}')

    if [[ "$STATUS" == "Running" && "$READY" == "2/2" ]]; then
      kill "$SPIN_PID" >/dev/null 2>&1
      wait "$SPIN_PID" 2>/dev/null || true
      echo -e "\r✅ Pod is Running (2/2)\n"
      return 0
    fi

    if [[ "$STATUS" =~ ImagePullBackOff|ErrImagePull|CrashLoopBackOff ]]; then
      kill "$SPIN_PID" >/dev/null 2>&1
      wait "$SPIN_PID" 2>/dev/null || true
      echo -e "\r❌ Pod entered $STATUS\n"
      return 1
    fi
    sleep 2
  done
}

deploy() {
  delete_pod
  apply_pod
  if wait_until_ready; then
    echo "🎉 Deployment successful!"
    exit 0
  else
    return 1
  fi
}

# ---------- Main flow ----------
if deploy; then
  exit 0
fi

# Retry once if allowed
if (( RETRY < MAX_RETRIES )); then
  echo "🔄 Retrying deployment ($((RETRY+1))/$MAX_RETRIES)…"
  RETRY=$((RETRY+1))
  if deploy; then
    exit 0
  fi
fi

echo "🚨 Deployment failed after $((RETRY+1)) attempt(s). Check pod logs:"
echo "    kubectl logs $POD_NAME -c <container-name>"
exit 1


# How to use

# 1. Make executable
# chmod +x deploy_spark_pod.sh

# 2. Run it
# ./deploy_spark_pod.sh

# This script will:
# - Delete any existing spark pod.
# - kubectl apply the manifest.
# - Show a spinner while waiting.
# - Detect a Running (2/2) state and exit 0, or retry once if the pod ends up in ImagePullBackOff / CrashLoopBackOff.
