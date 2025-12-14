#!/bin/bash

# Display total number of lines, words, and characters
echo "1. File statistics (lines, words, characters):"
wc SampleDataFile.txt
echo "---------------------------------------------"

# Display the top 15 rows
echo "2. Top 15 rows of the file:"
head -15 SampleDataFile.txt
echo "---------------------------------------------"

# Display the bottom 10 rows
echo "3. Bottom 10 rows of the file:"
tail -10 SampleDataFile.txt
echo "---------------------------------------------"

# Search and display all rows containing "Phoenix" (case-insensitive)
echo "4. Lines containing the word 'Phoenix':"
grep -i Phoenix SampleDataFile.txt
echo "---------------------------------------------"

# Display Username and City columns (assumes tab-delimited and fields 1 and 4)
echo "5. Display Username and City columns:"
cut -f1,4 SampleDataFile.txt
echo "---------------------------------------------"

# Check for duplicate usernames (column 1)
echo "6. Duplicate usernames and their counts:"
cut -f1 SampleDataFile.txt | sort | uniq -c
echo "---------------------------------------------"

# Extract first 3 columns to a new file
echo "7. Extracting first 3 columns to NewFile.txt:"
cut -f1-3 SampleDataFile.txt > NewFile.txt

# Convert tab-delimited to comma-delimited
echo "8. Converting tabs to commas in NewFile.txt:"
tr '\t' ',' < NewFile.txt > NewFile.csv
echo "Saved comma-delimited version as NewFile.csv"
