import pandas as pd

# Step 1: Load the dataset
df = pd.read_csv(
    'https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m1/data/synthetic_dataset.csv'
)

# Step 2: Replace names with pseudonyms (optional from previous step)
df['Name'] = ['User_' + str(i) for i in range(1, len(df) + 1)]

# Step 3: Define email redaction function
def redact_email(email):
    try:
        username, domain = email.split('@')
        redacted_username = (
            username[0] + '*' * (len(username) - 2) + username[-1]
            if len(username) > 2
            else '*' * len(username)
        )
        redacted_domain = (
            domain[0] + '*' * (len(domain) - 2) + domain[-1]
            if len(domain) > 2
            else '*' * len(domain)
        )
        return redacted_username + '@' + redacted_domain
    except:
        return '*' * len(email)  # fallback for malformed emails

# Step 4: Apply redaction
df['Email'] = df['Email'].apply(redact_email)

# Step 5: Show the modified DataFrame
print("Redacted email dataset:")
print(df.head())

# Optional: Save to file
# df.to_csv('redacted_email_dataset.csv', index=False)
