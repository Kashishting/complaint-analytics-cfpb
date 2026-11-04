import os
import sqlite3
import pandas as pd
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
os.makedirs('docs/charts', exist_ok=True)
conn =sqlite3.connect("data/complaints.db")
df = pd.read_sql_query("SELECT * FROM complaints_clean", conn)

#Exporting for dashboard tool
df.to_csv("data/complaints_clean.csv", index=False)

#1. Top 10 issued by volume
top = df['issue'].value_counts().head(10).sort_values()
top.plot.barh(figsize=(9,5),color='#2f6fb3')
plt.title('Top 10 Issues by Volume')
plt.xlabel('Complaints')
plt.tight_layout()
plt.savefig('docs/charts/01_top_issues.png', dpi=150)
plt.close()

#2. Monthly trend, excluding partial first and last months
monthly = df.groupby('year_month').size().iloc[1:-1]
monthly.plot(marker = 'o',figsize=(9,4),color ='#2f6fb3')
plt.title('Monthly complaints (partial first and last months excluded)')
plt.ylabel('Complaints')
plt.ylim(0,monthly.max()*1.2)
plt.tight_layout()
plt.savefig('docs/charts/02_monthly_trend.png', dpi=150)
plt.close()

#3. Relief rate by company, same issue (purchase problems)
sub = df[df["issue"].str.contains("purchase shown", case=False, na=False)]
print("Purchase-problem rows:", len(sub))
g = sub.groupby("company").agg(n=("complaint_id", "count"), relief=("got_relief", "mean"))
g = g[g["n"] >= 300]
if g.empty:
    print("Chart 3 skipped: no companies with 300+ purchase-problem complaints")
else:
    (g["relief"] * 100).sort_values().plot.barh(figsize=(9, 6), color="#2f6fb3")
    plt.title("Relief rate by company: purchase problems (300+ complaints)")
    plt.xlabel("% of complaints closed with relief")
    plt.tight_layout()
    plt.savefig("docs/charts/03_relief_by_company.png", dpi=150)
    plt.close()

#4. Share of late responses by company
late =(1-df['is_timely']).groupby(df['company']).sum().sort_values(ascending=False).head(10)
(late/(1-df["is_timely"]).sum()*100).sort_values().plot.barh(figsize=(9,5),color='#c0504d')
plt.title('Share of all late responses, top 10 companies')
plt.xlabel("percentage of all late responses")
plt.tight_layout
plt.savefig('docs/charts/04_late_share.png', dpi=150)
plt.close()

print("Charts saved to docs/charts")
