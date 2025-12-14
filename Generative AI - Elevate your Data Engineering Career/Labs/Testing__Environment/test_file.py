# Exploratory Data Analysis and Label Encoding for Categorical Data

import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.preprocessing import LabelEncoder

# Load dataset
url = "https://archive.ics.uci.edu/ml/machine-learning-databases/auto-mpg/auto-mpg.data"
column_names = ['mpg', 'cylinders', 'displacement', 'horsepower', 'weight', 'acceleration', 'model_year', 'origin', 'car_name']
data = pd.read_csv(url, delim_whitespace=True, names=column_names, na_values='?')

# Drop rows with missing values
data.dropna(inplace=True)

# Preview dataset
print("First 5 rows of the dataset:")
print(data.head())

# Summary statistics
print("\nSummary statistics:")
print(data.describe(include='all'))

# Data types and null values
print("\nData types and missing values:")
print(data.info())

# Distribution of numerical features
print("\nGenerating distribution plots...")
numerical_cols = data.select_dtypes(include=['float64', 'int64']).columns
for col in numerical_cols:
    plt.figure(figsize=(6, 4))
    sns.histplot(data[col], kde=True)
    plt.title(f'Distribution of {col}')
    plt.xlabel(col)
    plt.ylabel('Frequency')
    plt.tight_layout()
    plt.show()

# Correlation heatmap
print("\nGenerating correlation heatmap...")
data_numeric = data[numerical_cols]  # Only select numeric columns
plt.figure(figsize=(10, 8))
sns.heatmap(data_numeric.corr(), annot=True, cmap='coolwarm')
plt.title('Correlation Heatmap')
plt.tight_layout()
plt.show()

# Label encoding for categorical attributes
print("\nPerforming label encoding on categorical variables...")
categorical_cols = data.select_dtypes(include=['object']).columns
label_encoders = {}
for col in categorical_cols:
    le = LabelEncoder()
    data[col] = le.fit_transform(data[col])
    label_encoders[col] = le

print("\nLabel encoding completed. Transformed dataset:")
print(data.head())
