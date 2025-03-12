from pyspark.sql import SparkSession

spark = SparkSession.builder.appName("TestKestraPySpark").getOrCreate()

data = [("John", "Doe"), ("Jane", "Smith")]
df = spark.createDataFrame(data, ["First Name", "Last Name"])

df.show()

spark.stop()
