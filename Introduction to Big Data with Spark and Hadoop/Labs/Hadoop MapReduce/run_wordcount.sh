#!/bin/bash

# Step 1: Download Hadoop
echo "Downloading Hadoop..."
curl -O https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz

# Step 2: Extract Hadoop
echo "Extracting Hadoop..."
tar -xvf hadoop-3.3.6.tar.gz

# Step 3: Navigate into Hadoop directory
cd hadoop-3.3.6 || { echo "Hadoop folder not found!"; exit 1; }

# Step 4: Check if hadoop command works
echo "Verifying Hadoop command..."
bin/hadoop version

# Step 5: Download data.txt
echo "Downloading input text file..."
curl -O https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-BD0225EN-SkillsNetwork/labs/data/data.txt

# Step 6: Run MapReduce WordCount
echo "Running WordCount MapReduce..."
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount data.txt output

# Step 7: Check output directory
echo "Listing output directory contents..."
ls output

# Step 8: Display result
echo "Word count result:"
cat output/part-r-00000


# To use this script:

# Create the file:

# nano run_wordcount.sh

# Paste the script into the editor, then save and exit (Ctrl+O, Enter, Ctrl+X).

# Make it executable:

# chmod +x run_wordcount.sh

# Run the script:

# ./run_wordcount.sh

