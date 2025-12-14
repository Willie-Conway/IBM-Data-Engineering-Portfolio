# Hands-on Lab: Generative AI for Data Pipelines and ETL Workflows

# Step 1: Import Required Libraries
import pandas as pd
import sqlite3
from sklearn.preprocessing import LabelEncoder
import os

# Step 2: Define the Data URL
url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m2/data/Indian%20Liver%20Patient%20Dataset%20%28ILPD%29.csv"

# Step 3: Extract the Data from CSV into a Pandas DataFrame
df = pd.read_csv(url)
print("First 5 records:")
print(df.head())

# Step 4: Rename Columns for Clarity
df.columns = ['Age', 'Gender', 'Total_Bilirubin', 'Direct_Bilirubin', 'Alkaline_Phosphotase',
              'Alamine_Aminotransferase', 'Aspartate_Aminotransferase', 'Total_Proteins',
              'Albumin', 'Albumin_and_Globulin_Ratio', 'Liver_Disease']

# Step 5: Transform Categorical Data to Numeric
le = LabelEncoder()
df['Gender'] = le.fit_transform(df['Gender'])  # Male=1, Female=0

# Replace null values (if any) with mean for numerical columns
df['Albumin_and_Globulin_Ratio'].fillna(df['Albumin_and_Globulin_Ratio'].mean(), inplace=True)

# Convert 'Liver_Disease' values to binary (1 = Yes, 0 = No)
df['Liver_Disease'] = df['Liver_Disease'].apply(lambda x: 1 if x == 1 else 0)

# Print Transformed Data
print("\nTransformed Data Sample:")
print(df.head())

# Step 6: Create SQLite Database and Load the Data
db_path = 'liver_patient_data.db'

# Remove existing DB if needed for clean reruns
if os.path.exists(db_path):
    os.remove(db_path)

conn = sqlite3.connect(db_path)
df.to_sql('liver_patients', conn, index=False, if_exists='replace')

# Step 7: Verify Data Load
result_df = pd.read_sql_query("SELECT * FROM liver_patients LIMIT 5;", conn)
print("\nLoaded Data from SQLite:")
print(result_df)

# Step 8: Close the Connection
conn.close()
