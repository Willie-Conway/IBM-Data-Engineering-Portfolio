import findspark
findspark.init()

from pyspark import SparkContext, SparkConf
from pyspark.sql import SparkSession
from pyspark.sql.types import StructField, StructType, IntegerType, StringType

# Create Spark session
spark = SparkSession.builder \
    .master('spark://theiadocker-hirewillieco:7077') \
    .config('spark.executor.cores', '1') \
    .config('spark.executor.memory', '512m') \
    .getOrCreate()

# Create DataFrame
df = spark.createDataFrame(
    [
        (1, "foo"),
        (2, "bar"),
    ],
    StructType([
        StructField("id", IntegerType(), False),
        StructField("txt", StringType(), False),
    ])
)

# Print schema and data
print(df.dtypes)
print("\nDataFrame:")
df.show()
