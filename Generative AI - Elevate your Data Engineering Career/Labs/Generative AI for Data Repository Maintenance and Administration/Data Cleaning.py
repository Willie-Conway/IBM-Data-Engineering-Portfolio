# Hands-on Lab: Generative AI for Data Repository Maintenance and Administration

import pandas as pd
import numpy as np

# Load dataset from URL
url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m2/data/laptop_pricing_dataset_base.csv"
data = pd.read_csv(url)

# --- Handle Missing Values ---
# Identify columns with '?' values
cols_with_question_mark = data.columns[data.isin(['?']).any()]

# Replace '?' with the mean of the column (converted to numeric)
for col in cols_with_question_mark:
    mean_val = pd.to_numeric(data[col], errors='coerce').mean()
    data[col] = pd.to_numeric(data[col].replace('?', mean_val))

# Convert affected columns to float
data[cols_with_question_mark] = data[cols_with_question_mark].astype(float)

# --- Remove Duplicate Entries ---
print("Total number of rows before removal:", len(data))
data.drop_duplicates(inplace=True)
print("Total number of rows after removal:", len(data))

# --- Identify Outliers in 'Price' Attribute ---
mean_price = data['Price'].mean()
std_price = data['Price'].std()
outlier_threshold = 3

# Identify and extract outliers
outliers = data[(np.abs(data['Price'] - mean_price) > outlier_threshold * std_price)]
entries_with_outliers = data[data['Price'].isin(outliers['Price'])]

# Display results
print("\nEntries with price outliers:")
print(entries_with_outliers)

# --- END OF LAB ---
