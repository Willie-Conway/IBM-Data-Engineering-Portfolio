#!/bin/bash

# Set environment variables
export JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64
export SPARK_HOME=/home/project/spark-3.3.3-bin-hadoop3
export PATH=$SPARK_HOME/bin:$PATH

# Check if findspark is installed, if not, install it
if ! python3 -c "import findspark" &> /dev/null; then
  echo "Installing findspark..."
  pip3 install findspark
fi

# Run the Spark submit script
python3 submit.py






# How to use:

# Save this script as run_spark_submit.sh in the same directory as submit.py.

# Make it executable:

# chmod +x run_spark_submit.sh

# Run it:

# ./run_spark_submit.sh

# Note:
# Make sure your submit.py contains the correct Spark Master URL (replace theiadocker-yourname with your actual hostname).