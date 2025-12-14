#!/usr/bin/env bash
# Upload Hadoop configs + data.txt to HDFS (inside namenode container)

NN_CONTAINER="namenode"                             # container name
CONF_DIR_IN_NODE="$HADOOP_HOME/etc/hadoop"          # inside container
TMP_HOST_FILE="data.txt"                            # on host

# Helper to run HDFS commands inside the container
hdfs_in() {
  docker exec -i "${NN_CONTAINER}" hdfs dfs "$@"
}

echo "📁 Creating HDFS directory /user/root/input ..."
hdfs_in -mkdir -p /user/root/input

echo "📂 Uploading Hadoop XML config files to /user/root/input ..."
docker exec -i "${NN_CONTAINER}" bash -c \
  "hdfs dfs -put -f ${CONF_DIR_IN_NODE}/*.xml /user/root/input"

echo "⬇️  Downloading sample data file ..."
curl -s https://raw.githubusercontent.com/ibm-developer-skills-network/ooxwv-docker_hadoop/master/SampleMapReduce.txt \
  --output "$TMP_HOST_FILE"

echo "🚚 Copying data.txt into the container ..."
docker cp "$TMP_HOST_FILE" "${NN_CONTAINER}:/root/${TMP_HOST_FILE}"

echo "🚀 Uploading data.txt to HDFS at /user/root/ ..."
docker exec -i "${NN_CONTAINER}" bash -c \
  "hdfs dfs -put -f /root/${TMP_HOST_FILE} /user/root/"

echo "📄 Displaying /user/root/data.txt from HDFS:"
echo "------------------------------------------------------"
hdfs_in -cat /user/root/data.txt
echo "------------------------------------------------------"
echo "✅ Upload complete."




# How to Use

# Create the script:

# nano upload_to_hdfs.sh

# # Paste the code, then save (Ctrl+O, Enter) and exit (Ctrl+X)

# Make it executable:

# chmod +x upload_to_hdfs.sh

# Run it inside the namenode container:

# ./upload_to_hdfs.sh