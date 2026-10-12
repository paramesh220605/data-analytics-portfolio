import pandas as pd
import matplotlib.pyplot as plt

sales=pd.read_csv("../data/sales_transactions.csv",parse_dates=["Order_Date"])

# Data quality
print(sales.info())
print("\nMissing values:\n",sales.isna().sum())
print("Duplicate orders:",sales["Order_ID"].duplicated().sum())

# KPI analysis
revenue=sales["Revenue"].sum(); profit=sales["Profit"].sum()
print("Revenue:",round(revenue,2))
print("Profit:",round(profit,2))
print("Orders:",sales["Order_ID"].nunique())
print("Customers:",sales["Customer_ID"].nunique())
print("Profit Margin %:",round(profit/revenue*100,2))

# Monthly EDA
sales["Month"]=sales["Order_Date"].dt.to_period("M").astype(str)
monthly=sales.groupby("Month")[["Revenue","Profit"]].sum()
monthly.plot(kind="line",marker="o",title="Monthly Revenue and Profit")
plt.xticks(rotation=45); plt.tight_layout(); plt.show()

# Product performance
product_perf=sales.groupby(["Product_Name","Category"]).agg(
 Revenue=("Revenue","sum"),Profit=("Profit","sum"),Units=("Quantity","sum")
).sort_values("Revenue",ascending=False)
print(product_perf.head(10))

# RFM customer intelligence
snapshot=sales["Order_Date"].max()+pd.Timedelta(days=1)
rfm=sales.groupby("Customer_ID").agg(
 Recency=("Order_Date",lambda x:(snapshot-x.max()).days),
 Frequency=("Order_ID","nunique"),
 Monetary=("Revenue","sum")
).reset_index()
rfm["R_Score"]=pd.qcut(rfm["Recency"].rank(method="first"),4,labels=[4,3,2,1]).astype(int)
rfm["F_Score"]=pd.qcut(rfm["Frequency"].rank(method="first"),4,labels=[1,2,3,4]).astype(int)
rfm["M_Score"]=pd.qcut(rfm["Monetary"].rank(method="first"),4,labels=[1,2,3,4]).astype(int)

def segment(r):
    if r.R_Score>=3 and r.F_Score>=3 and r.M_Score>=3: return "High Value"
    if r.R_Score<=2 and r.F_Score>=3: return "At Risk"
    if r.R_Score>=3 and r.F_Score<=2: return "New/Promising"
    return "Regular"

rfm["Customer_Segment"]=rfm.apply(segment,axis=1)
print(rfm["Customer_Segment"].value_counts())
rfm.to_csv("../data/customer_rfm_output.csv",index=False)
