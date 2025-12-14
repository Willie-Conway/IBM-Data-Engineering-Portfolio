#!/bin/bash

# Step 1: Pull Hive image
echo "📦 Pulling Hive Docker image (apache/hive:4.0.0-alpha-1)..."
docker pull apache/hive:4.0.0-alpha-1

# Step 2: Run Hive container
echo "🚀 Starting Hive container (name: myhiveserver)..."
docker run -d \
  -p 10000:10000 -p 10002:10002 \
  --env SERVICE_NAME=hiveserver2 \
  -v /home/project/data:/hive_custom_data \
  --name myhiveserver \
  apache/hive:4.0.0-alpha-1

# Step 3: Wait a few seconds for the server to initialize
echo "⏳ Waiting for HiveServer2 to start up..."
sleep 10

# Step 4: Launch Beeline CLI
echo "🔗 Connecting to HiveServer2 via Beeline CLI..."
docker exec -it myhiveserver beeline -u 'jdbc:hive2://localhost:10000/'




# How to use this script

# Create the script file:

# nano setup_hive.sh

# Paste the code above, then save and exit (Ctrl+O, Enter, Ctrl+X)

# Make it executable:

# chmod +x setup_hive.sh

# Run it:

# ./setup_hive.sh
