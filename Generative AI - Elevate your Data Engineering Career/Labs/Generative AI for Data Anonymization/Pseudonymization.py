import pandas as pd

# Step 1: Load the dataset from the URL
df = pd.read_csv(
    'https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m1/data/synthetic_dataset.csv'
)

# Step 2: Display original dataset
print("Original dataset:")
print(df.head())

# Step 3: Replace 'Name' column with pseudonyms
df['Name'] = ['User_' + str(i) for i in range(1, len(df) + 1)]

# Step 4: Display modified dataset
print("\nModified dataset with pseudonymized names:")
print(df.head())

# Optional: Save to a new file
# df.to_csv("pseudonymized_dataset.csv", index=False)
