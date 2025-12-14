# Step: Transform Data - Label Encoding of Categorical Variables

import pandas as pd
from sklearn.preprocessing import LabelEncoder

# Load the dataset
url = "https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m2/data/Indian%20Liver%20Patient%20Dataset%20%28ILPD%29.csv"
df = pd.read_csv(url)

# Display original column types
print("Original Data Types:\n", df.dtypes)

# Identify and encode categorical columns
categorical_cols = df.select_dtypes(include=['object']).columns
label_encoders = {}

for col in categorical_cols:
    le = LabelEncoder()
    df[col] = le.fit_transform(df[col])
    label_encoders[col] = le

# Display transformed DataFrame and new column types
print("\nTransformed DataFrame:\n", df.head())
print("\nUpdated Data Types:\n", df.dtypes)
