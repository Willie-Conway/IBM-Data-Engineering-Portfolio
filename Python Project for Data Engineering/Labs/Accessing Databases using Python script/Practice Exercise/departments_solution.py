import sqlite3
import pandas as pd

def setup_departments_table():
    """Create and populate the Departments table with the required data"""
    try:
        # Connect to the existing STAFF database
        conn = sqlite3.connect('STAFF.db')
        
        # ===== DEPARTMENTS TABLE SETUP =====
        table_name = 'Departments'
        attributes = ['DEPT_ID', 'DEP_NAME', 'MANAGER_ID', 'LOC_ID']
        
        # Download and load the Departments CSV data
        csv_url = 'https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBMSkillsNetwork-PY0221EN-Coursera/labs/v2/Departments.csv'
        df = pd.read_csv(csv_url, names=attributes)
        
        # Create and populate the table
        df.to_sql(table_name, conn, if_exists='replace', index=False)
        print(f"\n{table_name} table created and populated successfully")
        
        # ===== APPEND NEW DEPARTMENT =====
        new_dept = {
            'DEPT_ID': [9],
            'DEP_NAME': ['Quality Assurance'],
            'MANAGER_ID': [30010],
            'LOC_ID': ['L0010']
        }
        pd.DataFrame(new_dept).to_sql(table_name, conn, if_exists='append', index=False)
        print("New department appended successfully")
        
        # ===== RUN REQUIRED QUERIES =====
        print("\n=== DEPARTMENT TABLE QUERIES ===")
        
        # Query a: View all entries
        query = f"SELECT * FROM {table_name}"
        print(f"\nQuery a: {query}")
        print(pd.read_sql(query, conn))
        
        # Query b: View only department names
        query = f"SELECT DEP_NAME FROM {table_name}"
        print(f"\nQuery b: {query}")
        print(pd.read_sql(query, conn))
        
        # Query c: Count total entries
        query = f"SELECT COUNT(*) AS Total_Departments FROM {table_name}"
        print(f"\nQuery c: {query}")
        print(pd.read_sql(query, conn))
        
    except Exception as e:
        print(f"\nError occurred: {e}")
    finally:
        # Close the connection
        if 'conn' in locals():
            conn.close()
            print("\nDatabase connection closed")

if __name__ == "__main__":
    setup_departments_table()