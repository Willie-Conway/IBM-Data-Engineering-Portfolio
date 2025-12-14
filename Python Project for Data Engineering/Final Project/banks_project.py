# Code for ETL operations on Country-GDP (Bank Market Cap) data

# Importing the required libraries
import requests
from bs4 import BeautifulSoup
import pandas as pd
import sqlite3
import numpy as np
from datetime import datetime
import re

# Initialize known variables
url = 'https://web.archive.org/web/20230908091635/https://en.wikipedia.org/wiki/List_of_largest_banks'
exchange_rate_csv_path = r'C:\Users\hirew\IBM-Data-Engineering-Portfolio\Python Project for Data Engineering\Final Project\exchange_rate.csv'
timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
output_csv_path = f'./Largest_banks_data_{timestamp}.csv'
db_name = 'Banks.db'
table_name = 'Largest_banks'
log_file = 'code_log.txt'

# Task 1: Logging function
def log_progress(message):
    '''Logs timestamped messages to a log file'''
    timestamp_format = '%Y-%b-%d-%H:%M:%S'
    now = datetime.now()
    timestamp = now.strftime(timestamp_format)
    with open(log_file, 'a') as f:
        f.write(timestamp + ' : ' + message + '\n')

# Task 2: Extraction of data
def extract(url, table_attribs):
    '''Extracts bank data from the given URL and returns a DataFrame'''
    try:
        html_page = requests.get(url).text
    except requests.exceptions.RequestException as e:
        log_progress(f"Failed to retrieve data from {url}: {e}")
        raise

    soup = BeautifulSoup(html_page, 'html.parser')
    tables = soup.find_all('tbody')
    target_table = None

    for table in tables:
        h2 = table.find_previous('h2')
        if h2 and h2.span and h2.span.get('id') == 'By_market_capitalization':
            target_table = table
            break

    if target_table is None:
        raise ValueError("Could not find the target table on the webpage.")

    data = []
    rows = target_table.find_all('tr')

    for row in rows[1:]:  # Skip header
        cols = row.find_all('td')
        if len(cols) >= 3:
            name = cols[1].text.strip().split('[')[0].strip()
            raw_cap = cols[2].text.strip().replace(',', '')
            match = re.search(r"[\d.]+", raw_cap)
            if match:
                market_cap = float(match.group())
                data.append({table_attribs[0]: name, table_attribs[1]: market_cap})

    df = pd.DataFrame(data, columns=table_attribs)
    return df

# Task 3: Transformation of data
def transform(df, csv_path):
    '''Transforms the data by converting USD market cap to other currencies'''
    exchange_rate_df = pd.read_csv(csv_path)
    exchange_rate = exchange_rate_df.set_index('Currency').to_dict()['Rate']

    required_currencies = ['GBP', 'EUR', 'INR']
    for curr in required_currencies:
        if curr not in exchange_rate:
            raise ValueError(f"Missing exchange rate for: {curr}")

    df['MC_GBP_Billion'] = np.round(df['MC_USD_Billion'] * exchange_rate['GBP'], 2)
    df['MC_EUR_Billion'] = np.round(df['MC_USD_Billion'] * exchange_rate['EUR'], 2)
    df['MC_INR_Billion'] = np.round(df['MC_USD_Billion'] * exchange_rate['INR'], 2)

    return df

# Task 4: Loading to CSV
def load_to_csv(df, output_path):
    '''Saves DataFrame to CSV'''
    df.to_csv(output_path, index=False)

# Task 5: Loading to Database
def load_to_db(df, sql_connection, table_name):
    '''Saves DataFrame to SQLite database'''
    df.to_sql(table_name, sql_connection, if_exists='replace', index=False)

# Task 6: Running queries
def run_query(query_statement, sql_connection):
    '''Runs and prints SQL query results'''
    print(f"Query: {query_statement}")
    query_output = pd.read_sql(query_statement, sql_connection)
    print(query_output)
    print()

# Main ETL process
log_progress('Preliminaries complete. Initiating ETL process')

# Extract
table_attribs = ['Name', 'MC_USD_Billion']
df = extract(url, table_attribs)
log_progress('Data extraction complete. Initiating Transformation process')

# Transform
df = transform(df, exchange_rate_csv_path)
log_progress('Data transformation complete. Initiating Loading process')

# Load to CSV
load_to_csv(df, output_csv_path)
log_progress(f'Data saved to CSV file: {output_csv_path}')

# Load to DB and Run Queries
try:
    conn = sqlite3.connect(db_name)
    log_progress('SQL Connection initiated')

    load_to_db(df, conn, table_name)
    log_progress('Data loaded to Database as a table, Executing queries')

    query_statements = [
        'SELECT * FROM Largest_banks',
        'SELECT AVG(MC_GBP_Billion) FROM Largest_banks',
        'SELECT Name FROM Largest_banks LIMIT 5'
    ]

    for query in query_statements:
        run_query(query, conn)

    log_progress('Process Complete')

finally:
    conn.close()
    log_progress('Server Connection closed')
