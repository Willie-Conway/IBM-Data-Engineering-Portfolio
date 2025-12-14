#!/bin/bash

echo "📥 Downloading and extracting Spark..."
wget https://archive.apache.org/dist/spark/spark-3.3.3/spark-3.3.3-bin-hadoop3.tgz && \
tar xf spark-3.3.3-bin-hadoop3.tgz && \
rm -f spark-3.3.3-bin-hadoop3.tgz

echo "✅ Spark extracted."

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
export SPARK_HOME=/home/project/spark-3.3.3-bin-hadoop3

echo "📁 Setting SPARK_HOME to: $SPARK_HOME"
echo "📁 Setting JAVA_HOME to: $JAVA_HOME"

# Create default Spark config file
echo "🛠 Creating spark-defaults.conf ..."
touch $SPARK_HOME/conf/spark-defaults.conf

# Write configuration to file
cat <<EOF > $SPARK_HOME/conf/spark-defaults.conf
spark.executor.memory 4g
spark.executor.cores 2
EOF

echo "✅ Configuration written to spark-defaults.conf"

# Change to SPARK_HOME
cd $SPARK_HOME || exit

# Start Spark master
echo "🚀 Starting Spark Master..."
./sbin/start-master.sh

echo "✅ Spark Master should now be running."
echo "🔗 Check the Spark Master UI at: http://localhost:8080 or http://<your-VM-IP>:8080"


# Instructions to Use:

# Open a new terminal.

# Save the script as a file:

# nano setup_and_start_spark_master.sh

# Paste the entire script above into the file and save (Ctrl + O, Enter, then Ctrl + X).

# Make it executable:

# chmod +x setup_and_start_spark_master.sh

# Run the script:

# ./setup_and_start_spark_master.sh

# After running the script, visit http://localhost:8080 or the provided VM/public IP on port 8080 to confirm the Spark Master is live.