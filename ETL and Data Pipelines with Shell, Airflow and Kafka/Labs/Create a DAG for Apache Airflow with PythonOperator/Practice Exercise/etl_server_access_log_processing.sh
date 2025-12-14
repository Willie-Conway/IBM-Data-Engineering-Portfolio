#!/bin/bash

# Set environment variable
export AIRFLOW_HOME=/home/project/airflow
DAG_NAME="ETL_Server_Access_Log_Processing.py"
DAGS_DIR="$AIRFLOW_HOME/dags"

# Step 1: Create DAG Python file
echo "Creating DAG file: $DAG_NAME"

cat <<EOF > $DAG_NAME
from datetime import timedelta
from airflow.models import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash_operator import BashOperator
from airflow.utils.dates import days_ago
import requests

input_file = 'web-server-access-log.txt'
extracted_file = 'extracted-data.txt'
transformed_file = 'transformed.txt'
output_file = 'capitalized.txt'

def download_file():
    url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DB0250EN-SkillsNetwork/labs/Apache%20Airflow/Build%20a%20DAG%20using%20Airflow/web-server-access-log.txt"
    with requests.get(url, stream=True) as response:
        response.raise_for_status()
        with open(input_file, 'wb') as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)
    print(f"File downloaded successfully: {input_file}")

def extract():
    with open(input_file, 'r') as infile, open(extracted_file, 'w') as outfile:
        for line in infile:
            fields = line.split('#')
            if len(fields) >= 4:
                outfile.write(fields[0] + "#" + fields[3] + "\\n")

def transform():
    with open(extracted_file, 'r') as infile, open(transformed_file, 'w') as outfile:
        for line in infile:
            outfile.write(line.upper().strip() + '\\n')

def load():
    with open(transformed_file, 'r') as infile, open(output_file, 'w') as outfile:
        for line in infile:
            outfile.write(line.strip() + '\\n')

def check():
    with open(output_file, 'r') as infile:
        for line in infile:
            print(line.strip())

default_args = {
    'owner': 'Willie Conway',
    'start_date': days_ago(0),
    'email': ['hire.willie.conway@gmail.com'],
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

dag = DAG(
    'etl-server-logs-dag',
    default_args=default_args,
    description='ETL DAG for processing server access logs',
    schedule_interval=timedelta(days=1),
)

download = PythonOperator(
    task_id='download',
    python_callable=download_file,
    dag=dag,
)

execute_extract = PythonOperator(
    task_id='extract',
    python_callable=extract,
    dag=dag,
)

execute_transform = PythonOperator(
    task_id='transform',
    python_callable=transform,
    dag=dag,
)

execute_load = PythonOperator(
    task_id='load',
    python_callable=load,
    dag=dag,
)

execute_check = PythonOperator(
    task_id='check',
    python_callable=check,
    dag=dag,
)

download >> execute_extract >> execute_transform >> execute_load >> execute_check
EOF

# Step 2: Move the file to the Airflow DAGs folder
echo "Moving DAG to Airflow DAGs directory..."
mkdir -p "$DAGS_DIR"
cp "$DAG_NAME" "$DAGS_DIR"

# Step 3: Verify DAG is recognized
echo "Verifying DAG is registered..."
airflow dags list | grep etl-server-logs-dag

# Step 4: Optional - Check for import errors
echo "Checking for import errors..."
airflow dags list-import-errors




# To Use:

# Save the script:

# nano etl_server_access_log_processing.sh

# Paste the contents and save (Ctrl+O, Enter, Ctrl+X).

# Make it executable:

# chmod +x etl_server_access_log_processing.sh

# Run it:

# ./etl_server_access_log_processing.sh