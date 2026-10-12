CREATE DATABASE IF NOT EXISTS enterprise_analytics;
USE enterprise_analytics;

CREATE TABLE customer_master (
 Customer_ID VARCHAR(20) PRIMARY KEY, Customer_Name VARCHAR(100),
 Customer_Segment VARCHAR(30), Region VARCHAR(30), First_Purchase_Date DATE,
 Industry VARCHAR(50), Account_Status VARCHAR(20)
);

CREATE TABLE product_master (
 Product_ID VARCHAR(20) PRIMARY KEY, Product_Name VARCHAR(100),
 Category VARCHAR(50), Target_Market VARCHAR(30),
 List_Price DECIMAL(12,2), Unit_Cost DECIMAL(12,2), Gross_Margin_Pct DECIMAL(8,2)
);

CREATE TABLE sales_transactions (
 Order_ID VARCHAR(20) PRIMARY KEY, Order_Date DATE, Customer_ID VARCHAR(20),
 Product_ID VARCHAR(20), Product_Name VARCHAR(100), Category VARCHAR(50),
 Target_Market VARCHAR(30), Region VARCHAR(30), Sales_Channel VARCHAR(30),
 Quantity INT, Unit_Price DECIMAL(12,2), Discount DECIMAL(5,2),
 Revenue DECIMAL(14,2), Unit_Cost DECIMAL(12,2), Total_Cost DECIMAL(14,2),
 Profit DECIMAL(14,2), Payment_Method VARCHAR(30), Customer_Type VARCHAR(30)
);