import pandas as pd
import numpy as np

def run_ecommerce_analysis(csv_path):
    print("=== Loading E-Commerce Sales Data ===")
    df = pd.read_csv(csv_path)
    df['order_date'] = pd.to_datetime(df['order_date'])
    df['gross_sales'] = df['unit_price'] * df['quantity']
    df['net_sales'] = df['gross_sales'] * (1 - df['discount_pct'])
    
    print("\n=== 1. Key Performance Indicators (KPIs) ===")
    completed_df = df[df['status'] == 'Completed']
    total_gmv = df['gross_sales'].sum()
    net_revenue = completed_df['net_sales'].sum()
    total_orders = df['order_id'].nunique()
    aov = net_revenue / completed_df['order_id'].nunique()
    overall_return_rate = (df['status'] == 'Returned').sum() / total_orders * 100
    
    print(f"Gross Merchandise Value (GMV): ${total_gmv:,.2f}")
    print(f"Net Revenue (Completed Orders): ${net_revenue:,.2f}")
    print(f"Total Orders Placed: {total_orders}")
    print(f"Average Order Value (AOV): ${aov:,.2f}")
    print(f"Overall Platform Return Rate: {overall_return_rate:.2f}%")
    
    print("\n=== 2. Category Performance Summary ===")
    category_summary = df.groupby('category').agg(
        total_units=('quantity', 'sum'),
        net_revenue=('net_sales', lambda x: x[df.loc[x.index, 'status'] == 'Completed'].sum()),
        total_orders=('order_id', 'count'),
        returned_orders=('status', lambda x: (x == 'Returned').sum())
    ).reset_index()
    category_summary['return_rate_pct'] = (category_summary['returned_orders'] / category_summary['total_orders']) * 100
    print(category_summary.sort_values(by='net_revenue', ascending=False).to_string(index=False))

    print("\n=== 3. Logistics & Fulfillment Method Analysis ===")
    fulfillment_summary = df.groupby('fulfillment_type').agg(
        total_orders=('order_id', 'count'),
        completed_orders=('status', lambda x: (x == 'Completed').sum()),
        returned_orders=('status', lambda x: (x == 'Returned').sum()),
        cancelled_orders=('status', lambda x: (x == 'Cancelled').sum())
    ).reset_index()
    fulfillment_summary['return_rate_pct'] = (fulfillment_summary['returned_orders'] / fulfillment_summary['total_orders']) * 100
    print(fulfillment_summary.to_string(index=False))

if __name__ == '__main__':
    run_ecommerce_analysis('../data/ecommerce_orders.csv')
