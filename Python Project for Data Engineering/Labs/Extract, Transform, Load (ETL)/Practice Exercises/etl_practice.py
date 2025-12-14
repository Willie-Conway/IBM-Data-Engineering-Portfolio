import glob
import pandas as pd
import xml.etree.ElementTree as ET
from datetime import datetime

log_file = "log_file.txt"
target_file = "transformed_data.csv"

def extract_from_csv(file_to_process):
    return pd.read_csv(file_to_process)

def extract_from_json(file_to_process):
    return pd.read_json(file_to_process, lines=True)

def extract_from_xml(file_to_process):
    dataframe = pd.DataFrame(columns=["car_model", "year_of_manufacture", "price", "fuel"])
    tree = ET.parse(file_to_process)
    root = tree.getroot()
    for car in root:
        model = car.find("car_model").text
        year = int(car.find("year_of_manufacture").text)
        price = float(car.find("price").text)
        fuel = car.find("fuel").text
        dataframe = pd.concat([dataframe, pd.DataFrame([{
            "car_model": model,
            "year_of_manufacture": year,
            "price": price,
            "fuel": fuel
        }])], ignore_index=True)
    return dataframe

def extract():
    extracted_data = pd.DataFrame(columns=["car_model", "year_of_manufacture", "price", "fuel"])
    
    for csvfile in glob.glob("*.csv"):
        if csvfile != target_file:
            extracted_data = pd.concat([extracted_data, extract_from_csv(csvfile)], ignore_index=True)
    
    for jsonfile in glob.glob("*.json"):
        extracted_data = pd.concat([extracted_data, extract_from_json(jsonfile)], ignore_index=True)
    
    for xmlfile in glob.glob("*.xml"):
        extracted_data = pd.concat([extracted_data, extract_from_xml(xmlfile)], ignore_index=True)
    
    return extracted_data

def transform(data):
    data['price'] = round(data['price'], 2)
    return data

def load_data(target_file, data_to_load):
    data_to_load.to_csv(target_file, index=False)

def log_progress(message):
    timestamp_format = '%Y-%h-%d-%H:%M:%S'
    now = datetime.now()
    timestamp = now.strftime(timestamp_format)
    with open(log_file, "a") as f:
        f.write(f"{timestamp},{message}\n")

# ETL Process
log_progress("ETL Job Started")

log_progress("Extract phase Started")
extracted_data = extract()
log_progress("Extract phase Ended")

log_progress("Transform phase Started")
transformed_data = transform(extracted_data)
print("Transformed Data:")
print(transformed_data)
log_progress("Transform phase Ended")

log_progress("Load phase Started")
load_data(target_file, transformed_data)
log_progress("Load phase Ended")

log_progress("ETL Job Ended")