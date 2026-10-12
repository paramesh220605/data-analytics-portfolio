# Customer Retention, Churn & Lifetime Value Analytics Platform
# Beginner-friendly Data Analyst Project
# Tools: Python, Pandas, NumPy, Matplotlib, Seaborn, Excel/Power BI, SQL

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# 1. Load data
df = pd.read_csv("customer_churn_ltv_dataset.csv")

# 2. Data inspection
print(df.head())
print(df.shape)
print(df.info())
print(df.isnull().sum())

# 3. Basic data cleaning
df = df.drop_duplicates()
df["Churn_Flag"] = df["Churn"].map({"Yes": 1, "No": 0})

# 4. KPI calculations
total_customers = df["Customer_ID"].nunique()
churned_customers = df.loc[df["Churn"] == "Yes", "Customer_ID"].nunique()
retained_customers = total_customers - churned_customers
churn_rate = churned_customers / total_customers * 100
retention_rate = retained_customers / total_customers * 100
avg_ltv = df["Simple_LTV"].mean()
total_customer_value = df["Simple_LTV"].sum()

print("Total Customers:", total_customers)
print("Churned Customers:", churned_customers)
print("Churn Rate:", round(churn_rate, 2), "%")
print("Retention Rate:", round(retention_rate, 2), "%")
print("Average LTV:", round(avg_ltv, 2))
print("Total Customer Value:", round(total_customer_value, 2))

# 5. Churn by contract
churn_by_contract = (
    df.groupby("Contract_Type")["Churn_Flag"]
      .mean()
      .mul(100)
      .reset_index(name="Churn_Rate")
)
print(churn_by_contract)

# 6. Churn by satisfaction
churn_by_satisfaction = (
    df.groupby("Satisfaction_Score")["Churn_Flag"]
      .mean()
      .mul(100)
      .reset_index(name="Churn_Rate")
)
print(churn_by_satisfaction)

# 7. LTV by contract
ltv_by_contract = (
    df.groupby("Contract_Type")["Simple_LTV"]
      .mean()
      .reset_index(name="Average_LTV")
)
print(ltv_by_contract)

# 8. High-risk customers
high_risk = df[df["Risk_Category"] == "High"].copy()
high_risk = high_risk.sort_values(["Simple_LTV", "Support_Tickets"], ascending=[False, False])
print(high_risk[[
    "Customer_ID", "Tenure_Months", "Contract_Type",
    "Support_Tickets", "Satisfaction_Score",
    "Monthly_Charges", "Simple_LTV", "Churn", "Risk_Category"
]].head(20)])

# 9. Visualization 1: Churn distribution
sns.countplot(data=df, x="Churn")
plt.title("Customer Churn Distribution")
plt.xlabel("Churn")
plt.ylabel("Number of Customers")
plt.tight_layout()
plt.show()

# 10. Visualization 2: Churn by contract
sns.barplot(data=churn_by_contract, x="Contract_Type", y="Churn_Rate")
plt.title("Churn Rate by Contract Type")
plt.ylabel("Churn Rate (%)")
plt.tight_layout()
plt.show()

# 11. Visualization 3: Satisfaction vs churn
sns.barplot(data=churn_by_satisfaction, x="Satisfaction_Score", y="Churn_Rate")
plt.title("Churn Rate by Satisfaction Score")
plt.ylabel("Churn Rate (%)")
plt.tight_layout()
plt.show()

# 12. Visualization 4: LTV distribution
plt.figure(figsize=(8,5))
sns.histplot(df["Simple_LTV"], bins=30, kde=True)
plt.title("Customer Lifetime Value Distribution")
plt.xlabel("Estimated LTV")
plt.tight_layout()
plt.show()

# 13. Export dashboard-ready summaries
df.to_csv("clean_customer_churn_ltv.csv", index=False)
churn_by_contract.to_csv("churn_by_contract.csv", index=False)
ltv_by_contract.to_csv("ltv_by_contract.csv", index=False)
high_risk.to_csv("high_risk_customers.csv", index=False)

print("Analysis completed. Dashboard-ready files exported.")
