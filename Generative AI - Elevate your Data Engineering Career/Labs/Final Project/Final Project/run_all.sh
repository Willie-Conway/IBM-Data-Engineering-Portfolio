#!/bin/bash

echo "Starting end-to-end data engineering pipeline..."

echo -e "\n[1] Creating data architecture and schema..."
python 1_data_architecture_and_schema.py

echo -e "\n[2] Running ETL pipeline..."
python 2_data_etl_pipeline.py

echo -e "\n[3] Querying and filtering data..."
python 3_querying_and_filtering.py

echo -e "\n[4] Running Apriori data mining..."
python 4_data_mining_apriori.py

echo -e "\nPipeline completed."



# How to use:

# Make sure the .py scripts are in the same folder as run_all.sh.

# Give execute permissions to the shell script:

# chmod +x run_all.sh

# Run the pipeline:

# ./run_all.sh