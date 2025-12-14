import requests
import pandas as pd
from bs4 import BeautifulSoup

# Initialize variables
url = 'https://web.archive.org/web/20230902185655/https://en.everybodywiki.com/100_Most_Highly-Ranked_Films'
df = pd.DataFrame(columns=["Film", "Year", "Rotten Tomatoes' Top 100"])

# Load and parse the webpage
try:
    html_page = requests.get(url, timeout=10)
    html_page.raise_for_status()  # Check for HTTP errors
    data = BeautifulSoup(html_page.text, 'html.parser')
except requests.exceptions.RequestException as e:
    print(f"Error fetching the webpage: {e}")
    exit()

# Find all tables and get rows from first table
tables = data.find_all('tbody')
if not tables:
    print("No tables found on the page")
    exit()

rows = tables[0].find_all('tr')

# Extract data from each row
for row in rows:
    col = row.find_all('td')
    if len(col) >= 4:  # Ensure we have all required columns
        try:
            film = str(col[1].contents[0]).strip()
            
            # Handle potential 'unranked' or other non-numeric year values
            year_str = str(col[2].contents[0]).strip().lower()
            year = int(year_str) if year_str.isdigit() else None
            
            rt_ranking = str(col[3].contents[0]).strip()
            
            data_dict = {
                "Film": film,
                "Year": year,  # This will be None for 'unranked' entries
                "Rotten Tomatoes' Top 100": rt_ranking
            }
            df = pd.concat([df, pd.DataFrame(data_dict, index=[0])], ignore_index=True)
        except (IndexError, ValueError, AttributeError) as e:
            print(f"Skipping row due to error: {e}")
            continue

print("Extracted Data with Rotten Tomatoes Info:")
print(df.head())  # Print first few rows to verify

# Save to CSV
try:
    df.to_csv('films_with_rotten_tomatoes.csv', index=False)
    print("Data successfully saved to films_with_rotten_tomatoes.csv")
except Exception as e:
    print(f"Error saving to CSV: {e}")