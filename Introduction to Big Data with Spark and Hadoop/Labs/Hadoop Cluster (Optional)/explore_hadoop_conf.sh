#!/usr/bin/env bash
# Script: explore_hadoop_conf.sh
# Purpose: List and optionally view Hadoop XML config files in the namenode container

NN_CONTAINER="namenode"                         # container name from docker‑compose.yml
CONF_DIR="/opt/hadoop-3.2.1/etc/hadoop"        # base config directory in the image

# Check container status
if ! docker ps --filter "name=${NN_CONTAINER}" --format '{{.Names}}' | grep -q "${NN_CONTAINER}"; then
  echo "❌ Container '${NN_CONTAINER}' is not running."
  exit 1
fi

echo "🔍 Listing Hadoop XML files in ${NN_CONTAINER}:${CONF_DIR}"
docker exec -it "${NN_CONTAINER}" ls "${CONF_DIR}"/*.xml || {
  echo "⚠️  Could not list XML files; check the path."
  exit 1
}

echo
read -p "👉 Enter the name of an XML file to view (or press Enter to skip): " FILE

if [[ -n "$FILE" ]]; then
  FULL_PATH="${CONF_DIR}/${FILE}"
  echo -e "\n📄 Contents of $FULL_PATH:\n"
  docker exec -it "${NN_CONTAINER}" cat "$FULL_PATH"
fi


# How to use

# Create and save the script:

# nano explore_hadoop_conf.sh     # paste, save, exit

# Make it executable:

# chmod +x explore_hadoop_conf.sh

# Run it:

# ./explore_hadoop_conf.sh