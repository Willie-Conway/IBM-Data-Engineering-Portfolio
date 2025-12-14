import pandas as pd
import random

# Load dataset
df = pd.read_csv('https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-AI0273EN-SkillsNetwork/labs/v1/m1/data/synthetic_dataset.csv')

# 1. Redact Name to show only vowels
def redact_name_vowels(name):
    vowels = 'aeiouAEIOU'
    return ''.join([char if char in vowels else '#' for char in name])
df['Name'] = df['Name'].apply(redact_name_vowels)

# 2. Replace Email with user_i@pseudo.com
df['Email'] = ['user_' + str(i) + '@pseudo.com' for i in range(1, len(df) + 1)]

# 3. Generalize Age to "30s", "40s", etc.
def generalize_age(age):
    return str(age)[0] + '0s'
df['Age'] = df['Age'].apply(generalize_age)

# 4. Add random noise to the first 5 digits of Contact Number
def noise_first_five(contact_number):
    contact_number = str(contact_number)
    noise = str(random.randint(10000, 99999)).zfill(5)
    return noise + contact_number[-5:]
df['Contact Number'] = df['Contact Number'].apply(noise_first_five)

# Preview final DataFrame
print("Final Anonymized Dataset Preview:")
print(df.head())
