#!/usr/bin/env bash
# Run a WordCount job on the Docker‑Compose Hadoop cluster

set -e

# Name of the NameNode container in docker‑compose.yml
NN_CONTAINER="namenode"

# Default text (overwritten if you pass a filename as first arg)
DEFAULT_TEXT=$'Italy Venice\nItaly Pizza\nPizza Pasta Gelato'
TMPFILE=/tmp/wordcount_input.txt

# If user supplied a file, copy it; else create default sample
if [[ -n $1 && -f $1 ]]; then
  cp "$1" "$TMPFILE"
  echo "ℹ️  Using user‑supplied file: $1"
else
  echo "$DEFAULT_TEXT" > "$TMPFILE"
  echo "ℹ️  Created default input file in $TMPFILE"
fi

echo "🚚 Copying input file into the NameNode container..."
docker cp "$TMPFILE" "$NN_CONTAINER:/root/input.txt"

echo "🗄️  Uploading file to HDFS and running WordCount..."
docker exec -i "$NN_CONTAINER" bash <<'EOF'
  set -e
  # Create/clean HDFS directories
  hdfs dfs -rm -r -f /user/root/input /user/root/output 2>/dev/null || true
  hdfs dfs -mkdir -p /user/root/input

  # Put the file into HDFS
  hdfs dfs -put -f /root/input.txt /user/root/input/

  # Run WordCount MapReduce example
  hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-*.jar \
        wordcount /user/root/input /user/root/output

  echo "✅ WordCount complete ‑ result:"
  hdfs dfs -cat /user/root/output/part-r-00000
EOF


# How to use

# Save the script:

# nano cluster_wordcount.sh     # paste the code and save

# Make it executable:

# chmod +x cluster_wordcount.sh

# Run (using default sample text):

# ./cluster_wordcount.sh

# or run with your own text file:

# ./cluster_wordcount.sh /path/to/mytext.txt