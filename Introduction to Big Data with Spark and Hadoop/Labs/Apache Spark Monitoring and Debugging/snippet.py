# --- FIX the UDF ------------------------------------------------------------
from pyspark.sql.functions import udf
import time

@udf("string")
def engine(cylinders):
    time.sleep(0.2)                       # keep delay so the UI shows tasks
    eng = {4: "inline-four", 6: "V6", 8: "V8"}
    return eng.get(cylinders, "other")    # safe default for 3, 5, etc.

# --- RE‑RUN the query -------------------------------------------------------
df = df.withColumn("engine", engine("cylinders"))

dfg = df.groupby("cylinders")
dfa = dfg.agg({"mpg": "avg", "engine": "first"})

dfa.show(truncate=False)




# Expected output:

# +---------+------------------+-------------+
# |cylinders|avg(mpg)          |first(engine)|
# +---------+------------------+-------------+
# |6        |19.985714285714288|V6           |
# |3        |20.55             |other        |
# |5        |27.366666666666664|other        |
# |4        |29.286764705882348|inline-four  |
# |8        |14.963106796116506|V8           |
# +---------+------------------+-------------+
