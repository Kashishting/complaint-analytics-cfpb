import pandas as pd
import sqlite3
import re

df = pd.read_csv("data/complaints.csv", low_memory=False)

# Make column names SQL-friendly: "Date received" -> "date_received"
df.columns = [re.sub(r"[^a-z0-9]+", "_", c.lower()).strip("_") for c in df.columns]

print(df.shape)
print(df.columns.tolist())

conn = sqlite3.connect("data/complaints.db")
df.to_sql("complaints", conn, if_exists="replace", index=False)
conn.close()
print("Loaded into data/complaints.db")
