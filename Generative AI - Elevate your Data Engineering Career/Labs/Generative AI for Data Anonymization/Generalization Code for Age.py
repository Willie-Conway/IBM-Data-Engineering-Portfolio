import pandas as pd

# Step 1: Load the dataset
df = pd.read_csv(
    'https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m1/data/synthetic_dataset.csv'
)

# Step 2: Optional pseudonymization and redaction
df['Name'] = ['User_' + str(i) for i in range(1, len(df) + 1)]

def redact_email(email):
    try:
        username, domain = email.split('@')
        redacted_username = username[0] + '*' * (len(username) - 2) + username[-1]
        redacted_domain = domain[0] + '*' * (len(domain) - 2) + domain[-1]
        return redacted_username + '@' + redacted_domain
    except:
        return '*' * len(email)

df['Email'] = df['Email'].apply(redact_email)

# Step 3: Generalization of Age
def generalize_age(age):
    if pd.isnull(age):
        return 'Unknown'
    try:
        age = int(age)
        return f"{age // 10 * 10}s"
    except ValueError:
        return 'Invalid'

df['Age'] = df['Age'].apply(generalize_age)

# Step 4: Show the updated DataFrame
print("Generalized Age dataset:")
print(df.head())

# Optional: Save to file
# df.to_csv('generalized_age_dataset.csv', index=False)
