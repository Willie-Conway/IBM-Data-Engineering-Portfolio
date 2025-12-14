# Step: Load DataFrame to SQLite Database and Query

import pandas as pd
from sklearn.preprocessing import LabelEncoder
import sqlite3

# Load the dataset
url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m2/data/Indian%20Liver%20Patient%20Dataset%20%28ILPD%29.csv"
df = pd.read_csv(url)

# Encode categorical columns
categorical_cols = df.select_dtypes(include=['object']).columns
label_encoders = {}
for col in categorical_cols:
    le = LabelEncoder()
    df[col] = le.fit_transform(df[col])
    label_encoders[col] = le

# Connect to SQLite database
conn = sqlite3.connect('Patient_record.db')

# Save DataFrame to SQL table
df.to_sql('Liver_patients', conn, index=False, if_exists='replace')  # replace ensures re-runs overwrite

# Query and display first 5 records to confirm load
query = "SELECT * FROM Liver_patients LIMIT 5"
result = pd.read_sql(query, conn)
print(result)

# Close the database connection
conn.close()
