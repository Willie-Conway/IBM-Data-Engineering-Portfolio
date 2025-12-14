#!/bin/bash

echo "🚀 Starting Cluster Node Setup for Dockerized Hadoop..."

# Step 1: Clone the repository
echo "📥 Cloning Hadoop cluster repo..."
git clone https://github.com/ibm-developer-skills-network/ooxwv-docker_hadoop.git

# Step 2: Change into the directory
cd ooxwv-docker_hadoop || { echo "❌ Failed to enter directory"; exit 1; }

# Step 3: Start the Docker containers
echo "🐳 Starting Hadoop cluster using docker-compose..."
docker-compose up -d

# Step 4: Show running containers
echo "📦 Running containers:"
docker ps --filter "name=namenode" --filter "name=datanode" --filter "name=historyserver" --filter "name=resourcemanager" --filter "name=nodemanager"

# Step 5: Connect to the NameNode container
echo "🔗 Connecting to NameNode container..."
echo "➡️ Run the following command manually to enter the NameNode shell:"
echo "    docker exec -it namenode /bin/bash"

echo "✅ Cluster setup complete."


# How to Use

# Save it as setup_cluster_hadoop.sh.

# Give it execute permissions:

# chmod +x setup_cluster_hadoop.sh

# Run the script:

# ./setup_cluster_hadoop.sh