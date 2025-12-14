import sqlite3

# Connect to SQLite database (or change to your DB connection)
conn = sqlite3.connect(':memory:')  # in-memory DB for demo
cursor = conn.cursor()

# Create example table schema
cursor.execute('''
CREATE TABLE heart_disease_prediction_dataset (
    age INTEGER,
    gender INTEGER,
    cp INTEGER,
    trestbps INTEGER,
    chol INTEGER,
    fbs INTEGER,
    restecg INTEGER,
    thalach INTEGER,
    exang INTEGER,
    oldpeak REAL,
    slope INTEGER,
    ca INTEGER,
    thal INTEGER,
    num INTEGER
)
''')

# (Optional) Insert demo data here or load from CSV/file if needed
# For now, we will just run queries assuming data exists

# Query 1: Age Distribution
query1 = '''
SELECT 
    MIN(age) AS min_age,
    MAX(age) AS max_age,
    AVG(age) AS avg_age
FROM 
    heart_disease_prediction_dataset;
'''

# Query 2: Gender Analysis
query2 = '''
SELECT 
    gender,
    COUNT(*) AS patient_count
FROM 
    heart_disease_prediction_dataset
GROUP BY 
    gender;
'''

# Query 3: Chest Pain Frequency
query3 = '''
SELECT 
    cp,
    COUNT(*) AS pain_frequency
FROM 
    heart_disease_prediction_dataset
GROUP BY 
    cp;
'''

# Query 4: Age Group and Heart Disease Distribution
query4 = '''
SELECT 
    CASE
        WHEN age BETWEEN 20 AND 30 THEN '20-30'
        WHEN age BETWEEN 31 AND 40 THEN '31-40'
        WHEN age BETWEEN 41 AND 50 THEN '41-50'
        WHEN age BETWEEN 51 AND 60 THEN '51-60'
        WHEN age BETWEEN 61 AND 70 THEN '61-70'
        ELSE 'Above 70'
    END AS age_group,
    SUM(CASE WHEN num = 1 THEN 1 ELSE 0 END) AS heart_disease_count,
    SUM(CASE WHEN num = 0 THEN 1 ELSE 0 END) AS no_heart_disease_count
FROM 
    heart_disease_prediction_dataset
GROUP BY 
    age_group
ORDER BY 
    age_group;
'''

# Function to execute and print query results
def run_query(query, description):
    print(f"\n--- {description} ---")
    try:
        cursor.execute(query)
        rows = cursor.fetchall()
        for row in rows:
            print(row)
    except Exception as e:
        print(f"Error executing query: {e}")

# Run queries
run_query(query1, "Age Distribution")
run_query(query2, "Gender Analysis")
run_query(query3, "Chest Pain Frequency")
run_query(query4, "Age Group & Heart Disease Distribution")

# Close connection
conn.close()
