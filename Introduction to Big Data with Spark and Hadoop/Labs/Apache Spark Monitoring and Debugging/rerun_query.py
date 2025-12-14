from pyspark.sql import SparkSession
from pyspark.sql.functions import udf
import time

spark = SparkSession.builder.getOrCreate()

df = spark.read.csv("/home/root/cars.csv", header=True, inferSchema=True) \
       .repartition(32) \
       .cache()

@udf("string")
def engine(cylinders):
    time.sleep(0.2)
    eng = {4: "inline-four", 6: "V6", 8: "V8"}
    return eng.get(cylinders, "other")

df = df.withColumn("engine", engine("cylinders"))
dfa = df.groupby("cylinders").agg({"mpg": "avg", "engine": "first"})

dfa.show(truncate=False)
