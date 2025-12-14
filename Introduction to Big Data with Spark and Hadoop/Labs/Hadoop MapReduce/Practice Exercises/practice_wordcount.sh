#!/usr/bin/env bash
set -e

HADOOP_DIR="/home/project/hadoop-3.3.6"   # adjust if you extracted elsewhere
HADOOP=$HADOOP_DIR/bin/hadoop

echo "🧹 Cleaning up old input & output..."
rm -f  "$HADOOP_DIR/data.txt"
rm -rf "$HADOOP_DIR/output"

echo "📝 Creating data.txt ..."
cat <<EOF > "$HADOOP_DIR/data.txt"
Italy Venice
Italy Pizza
Pizza Pasta Gelato
EOF
echo "✅ Created data.txt:"
cat "$HADOOP_DIR/data.txt"
echo "--------------------------------------"

echo "🚀 Running Hadoop WordCount job ..."
"$HADOOP" jar "$HADOOP_DIR/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar" \
          wordcount "$HADOOP_DIR/data.txt" "$HADOOP_DIR/output"

echo "📄 WordCount output:"
cat "$HADOOP_DIR/output/part-r-00000"



# How to use

# # inside hadoop-3.3.6 folder
# nano practice_wordcount.sh       # paste the script

# chmod +x practice_wordcount.sh   # make it executable

# ./practice_wordcount.sh          # run it