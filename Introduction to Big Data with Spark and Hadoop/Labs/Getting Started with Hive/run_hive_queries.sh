#!/bin/bash

# Step 1: Copy .hql file into the running Hive container
echo "📁 Copying Hive query file to container..."
docker cp load_employee_data.hql myhiveserver:/load_employee_data.hql

# Step 2: Execute the Hive query script inside the container using Beeline
echo "🐝 Running Hive queries inside the container..."
docker exec -it myhiveserver beeline -u 'jdbc:hive2://localhost:10000/' -f /load_employee_data.hql





# How to use this:

# Create the .hql file:

# nano load_employee_data.hql

# Paste the Hive queries, then save and exit.

# Create the shell script:

# nano run_hive_queries.sh

# Paste the Bash script, then save and exit.

# Make it executable:

# chmod +x run_hive_queries.sh

# Run the script:

# ./run_hive_queries.sh