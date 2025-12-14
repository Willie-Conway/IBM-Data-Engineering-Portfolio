#!/usr/bin/env bash
# --------------------------------------------------------------------
# start_cluster_and_explore.sh
#
# * Ensures a Docker‑Compose Hadoop cluster is up (namenode container)
# * Lists Hadoop XML config files inside the namenode container
# * Optionally displays the contents of a chosen XML file
#
# Usage:
#   ./start_cluster_and_explore.sh  [compose_directory]
#
# If compose_directory is omitted, the default path is
#   /home/project/ooxwv-docker_hadoop
# --------------------------------------------------------------------

# -------- Default values -------------------------------------------
DEFAULT_DIR="/home/project/ooxwv-docker_hadoop"
COMPOSE_DIR="${1:-$DEFAULT_DIR}"        # arg1 or default
NN_CONTAINER="namenode"
CONF_DIR="/opt/hadoop-3.2.1/etc/hadoop" # inside container
# --------------------------------------------------------------------

set -e

echo "🔍 Using compose directory: $COMPOSE_DIR"

# -------- Detect available Compose command -------------------------
if command -v docker-compose >/dev/null 2>&1; then
  COMPOSE_CMD="docker-compose"
elif docker compose version >/dev/null 2>&1; then
  COMPOSE_CMD="docker compose"
else
  echo "❌ Neither 'docker-compose' nor 'docker compose' found in PATH."
  exit 1
fi
echo "ℹ️  Using Compose command: $COMPOSE_CMD"

# -------- Ensure the cluster is running ----------------------------
if ! docker ps --filter "name=${NN_CONTAINER}" --format '{{.Names}}' | grep -q "${NN_CONTAINER}"; then
  echo "🔧 Namenode container not running – starting cluster ..."
  if [[ ! -d $COMPOSE_DIR ]]; then
    echo "❌ Compose directory '$COMPOSE_DIR' not found. Aborting."
    exit 1
  fi
  (cd "$COMPOSE_DIR" && $COMPOSE_CMD up -d)
else
  echo "✅ Namenode container already running."
fi

# -------- List XML configuration files -----------------------------
echo
echo "📄 Hadoop XML config files in ${NN_CONTAINER}:${CONF_DIR}:"
docker exec "${NN_CONTAINER}" ls "${CONF_DIR}"/*.xml
echo

# -------- Prompt user to view a file -------------------------------
read -rp "👉 Enter an XML filename to view (or press Enter to exit): " FILE_CHOICE
if [[ -n $FILE_CHOICE ]]; then
  FULL_PATH="${CONF_DIR}/${FILE_CHOICE}"
  echo -e "\n📑 Showing ${FULL_PATH}:\n"
  docker exec -it "${NN_CONTAINER}" cat "$FULL_PATH"
else
  echo "👋 Exiting without viewing a file."
fi



# # How to use

# chmod +x start_cluster_and_explore.sh

# # Run with default compose directory
# ./start_cluster_and_explore.sh

# # Or supply a different directory
# ./start_cluster_and_explore.sh /exact/path/to/ooxwv-docker_hadoop
