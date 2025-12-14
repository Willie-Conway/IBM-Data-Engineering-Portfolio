# test_file.py
import pandas as pd
import random

# Step 1: Load the dataset
df = pd.read_csv(
    'https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m1/data/synthetic_dataset.csv'
)

# Step 2: Pseudonymize Name
df['Name'] = ['User_' + str(i) for i in range(1, len(df) + 1)]

# Step 3: Redact Email
def redact_email(email):
    try:
        username, domain = email.split('@')
        redacted_username = username[0] + '*' * (len(username) - 2) + username[-1]
        redacted_domain = domain[0] + '*' * (len(domain) - 2) + domain[-1]
        return redacted_username + '@' + redacted_domain
    except:
        return '*' * len(email)

df['Email'] = df['Email'].apply(redact_email)

# Step 4: Generalize Age
def generalize_age(age):
    if pd.isnull(age):
        return 'Unknown'
    try:
        age = int(age)
        return f"{age // 10 * 10}s"
    except ValueError:
        return 'Invalid'

df['Age'] = df['Age'].apply(generalize_age)

# Step 5: Add Random Noise to Contact Number (last 5 digits)
def add_random_noise(contact_number):
    try:
        contact_str = str(contact_number)
        if len(contact_str) == 10:
            noise = str(random.randint(10000, 99999))
            return contact_str[:5] + noise
        else:
            return contact_str
    except:
        return contact_number

df['Contact Number'] = df['Contact Number'].apply(add_random_noise)

# Step 6: Display the modified DataFrame
print("✅ Modified Anonymized Dataset (First 5 Rows):")
print(df.head())

# Optional: Save to CSV
# df.to_csv('/home/project/anonymized_dataset.csv', index=False)
