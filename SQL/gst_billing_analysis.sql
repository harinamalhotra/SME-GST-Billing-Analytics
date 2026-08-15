CREATE DATABASE SME_Billing_GST;
USE SME_Billing_GST;
CREATE TABLE gst_billing (

    Invoice_ID VARCHAR(20),
    Invoice_Date DATE,
    Customer_Name VARCHAR(200),
    State VARCHAR(50),
    GST_Number VARCHAR(20),
    Category VARCHAR(50),
    Product VARCHAR(100),
    Quantity INT,
    Unit_Price DECIMAL(10,2),
    Discount_Percentage INT,
    GST_Rate INT,
    CGST DECIMAL(10,2),
    SGST DECIMAL(10,2),
    IGST DECIMAL(10,2),
    Total_Amount DECIMAL(12,2),
    Payment_Method VARCHAR(30),
    Payment_Status VARCHAR(30),
    Salesperson VARCHAR(50)

);
SELECT COUNT(*) AS Total_Records
FROM gst_billing;

SELECT *
FROM gst_billing
LIMIT 5;

#How much total revenue did the company generate?
SELECT
ROUND(SUM(Total_Amount),2) AS Total_Revenue
FROM gst_billing;

#Total Number of Invoices
SELECT
COUNT(*) AS Total_Invoices
FROM gst_billing;

#Average Invoice Value
SELECT
ROUND(AVG(Total_Amount),2) AS Average_Invoice_Value
FROM gst_billing;

#Revenue by product category
SELECT
Category,
ROUND(SUM(Total_Amount),2) AS Revenue
FROM gst_billing
GROUP BY Category
ORDER BY Revenue DESC;

#Top 10 selling products
SELECT
Product,
SUM(Quantity) AS Units_Sold
FROM gst_billing
GROUP BY Product
ORDER BY Units_Sold DESC
LIMIT 10;

#How do sales change month by month?
SELECT
DATE_FORMAT(Invoice_Date, '%Y-%m') AS Month,
ROUND(SUM(Total_Amount),2) AS Revenue
FROM gst_billing
GROUP BY Month
ORDER BY Month;

#Which states generate the highest revenue?
SELECT
State,
ROUND(SUM(Total_Amount),2) AS Revenue
FROM gst_billing
GROUP BY State
ORDER BY Revenue DESC;

#How much GST has been collected?
SELECT
ROUND(SUM(CGST),2) AS Total_CGST,
ROUND(SUM(SGST),2) AS Total_SGST,
ROUND(SUM(IGST),2) AS Total_IGST
FROM gst_billing;

#Top 10 customers by revenue
SELECT
Customer_Name,
ROUND(SUM(Total_Amount),2) AS Revenue
FROM gst_billing
GROUP BY Customer_Name
ORDER BY Revenue DESC
LIMIT 10;

#Payment Method Analysis
SELECT
Payment_Method,
COUNT(*) AS Transactions,
ROUND(SUM(Total_Amount),2) AS Revenue
FROM gst_billing
GROUP BY Payment_Method
ORDER BY Revenue DESC;

#Payment status summary
SELECT
Payment_Status,
COUNT(*) AS Total_Invoices,
ROUND(SUM(Total_Amount),2) AS Revenue
FROM gst_billing
GROUP BY Payment_Status;

#Best Salesperson
SELECT
Salesperson,
ROUND(SUM(Total_Amount),2) AS Revenue
FROM gst_billing
GROUP BY Salesperson
ORDER BY Revenue DESC;

#Highest value Invoice
SELECT *
FROM gst_billing
ORDER BY Total_Amount DESC
LIMIT 1;

#Average revenue per state
SELECT
State,
ROUND(AVG(Total_Amount),2) AS Average_Revenue
FROM gst_billing
GROUP BY State
ORDER BY Average_Revenue DESC;

#Category-wise GST collection
SELECT
Category,
ROUND(SUM(CGST + SGST + IGST),2) AS GST_Collected
FROM gst_billing
GROUP BY Category
ORDER BY GST_Collected DESC;

#Who are the best-performing salespersons?
SELECT
    Salesperson,
    ROUND(SUM(Total_Amount),2) AS Revenue,
    RANK() OVER (ORDER BY SUM(Total_Amount) DESC) AS Sales_Rank
FROM gst_billing
GROUP BY Salesperson;

#Top Product in Each Category
WITH ProductSales AS
(
    SELECT
        Category,
        Product,
        SUM(Quantity) AS Units_Sold,
        RANK() OVER
        (
            PARTITION BY Category
            ORDER BY SUM(Quantity) DESC
        ) AS Product_Rank
    FROM gst_billing
    GROUP BY Category, Product
)

SELECT *
FROM ProductSales
WHERE Product_Rank = 1;

#Running Revenue Trend
SELECT
    Invoice_Date,
    ROUND(SUM(Total_Amount),2) AS Daily_Revenue,
    ROUND(
        SUM(SUM(Total_Amount))
        OVER(ORDER BY Invoice_Date),
    2) AS Running_Revenue
FROM gst_billing
GROUP BY Invoice_Date
ORDER BY Invoice_Date;

#Create a View
CREATE VIEW Monthly_Sales AS

SELECT

DATE_FORMAT(Invoice_Date,'%Y-%m') AS Month,

ROUND(SUM(Total_Amount),2) AS Revenue

FROM gst_billing

GROUP BY Month;

SELECT * FROM Monthly_Sales;

#Create an Index
CREATE INDEX idx_invoice_date
ON gst_billing(Invoice_Date);

SHOW CREATE VIEW Monthly_Sales;