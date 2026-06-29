CREATE DATABASE Telecom_Customer

USE Telecom_Customer

CREATE TABLE dbo.churn_customer (
    customerID          VARCHAR(20)   PRIMARY KEY,
    gender              VARCHAR(10),
    SeniorCitizen       TINYINT,         
    Partner             VARCHAR(5),
    Dependents          VARCHAR(5),
    tenure              INT,              
    PhoneService        VARCHAR(5),
    MultipleLines       VARCHAR(20),
    InternetService     VARCHAR(20),
    OnlineSecurity      VARCHAR(20),
    OnlineBackup        VARCHAR(20),
    DeviceProtection    VARCHAR(20),
    TechSupport         VARCHAR(20),
    StreamingTV         VARCHAR(20),
    StreamingMovies     VARCHAR(20),
    Contract            VARCHAR(20),      
    PaperlessBilling    VARCHAR(5),
    PaymentMethod       VARCHAR(40),
    MonthlyCharges      DECIMAL(8,2),
    TotalCharges        DECIMAL(10,2),    
    Churn               VARCHAR(5)        
)




SELECT * FROM churn_customer

-- Row Count and Churn Overview

SELECT 
COUNT (*) AS Total_customers,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS Churned_customer,
SUM(CASE WHEN Churn = 'No' THEN 1 ELSE 0 END) AS Retained_customer,
SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100 / COUNT (*) AS Percentage
FROM
churn_customer

-- 26% Churned Customers

-- Checking Nulls
SELECT
SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) AS Null_customers,
SUM(CASE WHEN tenure IS NULL THEN 1 ELSE 0 END) AS Null_tenure,
SUM(CASE WHEN MonthlyCharges IS NULL THEN 1 ELSE 0 END) AS Null_charges,
SUM(CASE WHEN TotalCharges IS NULL THEN 1 ELSE 0 END) AS Null_total_charges,
SUM(CASE WHEN Churn IS NULL THEN 1 ELSE 0 END) AS Null_churn
FROM
churn_customer

-- distinct value check 

SELECT DISTINCT Contract FROM churn_customer ORDER BY 1

SELECT DISTINCT InternetService FROM churn_customer ORDER BY 1

SELECT DISTINCT PaymentMethod FROM churn_customer ORDER BY 1

SELECT DISTINCT Churn FROM churn_customer ORDER BY 1

-- outliers

SELECT * FROM churn_customer

SELECT
MIN(tenure) AS min_tenure,
MAX(tenure) AS max_tenure,
MIN(MonthlyCharges) as min_mcharges,
MAX(MonthlyCharges) as max_mcharges,
MIN(TotalCharges) as min_tcharges,
MAX(TotalCharges) as max_tcharges
FROM
churn_customer

-- fixing null values

SELECT 
customerID,
tenure,
MonthlyCharges,
TotalCharges,
Churn
FROM
churn_customer
WHERE 
TotalCharges IS NULL

UPDATE churn_customer
SET TotalCharges = MonthlyCharges
WHERE TotalCharges IS NULL

SELECT
COUNT(*) AS null_records
FROM
churn_customer
WHERE 
TotalCharges IS NULL

ALTER TABLE Churn_customer ADD
TenureBucket VARCHAR(20),
ChurnFlag TINYINT,
NumAddons TINYINT,
ChargesBucket VARCHAR(20)

UPDATE churn_customer
SET TenureBucket =
	CASE
		WHEN tenure BETWEEN 0 AND 12 THEN '01. 0-12 Months'
		WHEN tenure BETWEEN 13 AND 24 THEN '02. 13-24 Months'
		WHEN tenure BETWEEN 25 AND 36 THEN '03. 25-36 Months'
		WHEN tenure BETWEEN 37 AND 48 THEN '04. 37-48 Months'
		WHEN tenure BETWEEN 48 AND 60 THEN '05. 48-60 Months'
		ELSE '06. 60+ Months'
	END

UPDATE churn_customer
SET ChurnFlag = 
	CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END

UPDATE churn_customer
SET NumAddons = 
	(CASE WHEN OnlineSecurity   = 'Yes' THEN 1 ELSE 0 END) +
    (CASE WHEN OnlineBackup     = 'Yes' THEN 1 ELSE 0 END) +
    (CASE WHEN DeviceProtection = 'Yes' THEN 1 ELSE 0 END) +
    (CASE WHEN TechSupport      = 'Yes' THEN 1 ELSE 0 END) +
    (CASE WHEN StreamingTV      = 'Yes' THEN 1 ELSE 0 END) +
    (CASE WHEN StreamingMovies  = 'Yes' THEN 1 ELSE 0 END)

UPDATE churn_customer
SET ChargesBucket =
	CASE
		WHEN MonthlyCharges <  30 THEN '01. Under $30'
        WHEN MonthlyCharges <  50 THEN '02. $30–$50'
        WHEN MonthlyCharges <  70 THEN '03. $50–$70'
        WHEN MonthlyCharges <  90 THEN '04. $70–$90'
		ELSE '05. $90+'
	END

SELECT TOP 5
customerID,
tenure,
TenureBucket,
Churn,
ChurnFlag,
NumAddOns,
MonthlyCharges, 
ChargesBucket
FROM churn_customer

SELECT
COUNT (*) AS Total_customers,
SUM(ChurnFlag) AS Total_churn,
COUNT (*) - SUM(ChurnFlag) AS Active_customers,
CAST(AVG(CAST(ChurnFlag as FLOAT))*100 AS DECIMAL(12,2)) AS Percentage,
AVG(MonthlyCharges) AS AVG_mcharges,
SUM(MonthlyCharges) AS Total_mcharges,
SUM(MonthlyCharges) * 12 AS Annual_mcharges
FROM
churn_customer

SELECT * FROM churn_customer

SELECT
Contract,
COUNT (*) AS Total_customers,
SUM(ChurnFlag) AS Total_churn,
COUNT (*) - SUM(ChurnFlag) AS Active_customers,
CAST(AVG(CAST(ChurnFlag as FLOAT))*100 AS DECIMAL(12,2)) AS Percentage,
CAST(AVG(MonthlyCharges) AS DECIMAL(12,2)) AS AVG_mcharges
FROM
churn_customer
GROUP BY
Contract
ORDER BY
Percentage DESC


SELECT
gender,
COUNT (*) AS Total_customers,
SUM(ChurnFlag) AS Total_churn,
COUNT (*) - SUM(ChurnFlag) AS Active_customers,
CAST(AVG(CAST(ChurnFlag as FLOAT))*100 AS DECIMAL(12,2)) AS Percentage,
CAST(AVG(MonthlyCharges) AS DECIMAL(12,2)) AS AVG_mcharges
FROM
churn_customer
GROUP BY
gender
ORDER BY
Percentage DESC

SELECT
SeniorCitizen,
COUNT (*) AS Total_customers,
SUM(ChurnFlag) AS Total_churn,
COUNT (*) - SUM(ChurnFlag) AS Active_customers,
CAST(AVG(CAST(ChurnFlag as FLOAT))*100 AS DECIMAL(12,2)) AS Percentage,
CAST(AVG(MonthlyCharges) AS DECIMAL(12,2)) AS AVG_mcharges
FROM
churn_customer
GROUP BY
SeniorCitizen
ORDER BY
Percentage DESC

SELECT
Partner,
COUNT (*) AS Total_customers,
SUM(ChurnFlag) AS Total_churn,
COUNT (*) - SUM(ChurnFlag) AS Active_customers,
CAST(AVG(CAST(ChurnFlag as FLOAT))*100 AS DECIMAL(12,2)) AS Percentage,
CAST(AVG(MonthlyCharges) AS DECIMAL(12,2)) AS AVG_mcharges
FROM
churn_customer
GROUP BY
Partner
ORDER BY
Percentage DESC

SELECT
PaymentMethod,
COUNT (*) AS Total_customers,
SUM(ChurnFlag) AS Total_churn,
COUNT (*) - SUM(ChurnFlag) AS Active_customers,
CAST(AVG(CAST(ChurnFlag as FLOAT))*100 AS DECIMAL(12,2)) AS Percentage,
CAST(AVG(MonthlyCharges) AS DECIMAL(12,2)) AS AVG_mcharges
FROM
churn_customer
GROUP BY
PaymentMethod
ORDER BY
Percentage DESC

SELECT
TenureBucket,
COUNT (*) AS Total_customers,
SUM(ChurnFlag) AS Total_churn,
COUNT (*) - SUM(ChurnFlag) AS Active_customers,
CAST(AVG(CAST(ChurnFlag as FLOAT))*100 AS DECIMAL(12,2)) AS Percentage,
CAST(AVG(MonthlyCharges) AS DECIMAL(12,2)) AS AVG_mcharges
FROM
churn_customer
GROUP BY
TenureBucket
ORDER BY
Percentage DESC

SELECT
InternetService,
COUNT (*) AS Total_customers,
SUM(ChurnFlag) AS Total_churn,
COUNT (*) - SUM(ChurnFlag) AS Active_customers,
CAST(AVG(CAST(ChurnFlag as FLOAT))*100 AS DECIMAL(12,2)) AS Percentage,
CAST(AVG(MonthlyCharges) AS DECIMAL(12,2)) AS AVG_mcharges
FROM
churn_customer
GROUP BY
InternetService
ORDER BY
Percentage DESC

SELECT
NumAddons,
COUNT (*) AS Total_customers,
SUM(ChurnFlag) AS Total_churn,
COUNT (*) - SUM(ChurnFlag) AS Active_customers,
CAST(AVG(CAST(ChurnFlag as FLOAT))*100 AS DECIMAL(12,2)) AS Percentage,
CAST(AVG(MonthlyCharges) AS DECIMAL(12,2)) AS AVG_mcharges
FROM
churn_customer
GROUP BY
NumAddons
ORDER BY
Percentage DESC


SELECT
customerID,
NumAddons,
Contract,
tenure,
TenureBucket,
InternetService,
MonthlyCharges,
TotalCharges,
NumAddOns,
PaymentMethod
FROM
churn_customer
WHERE
Churn = 'NO' AND Contract = 'Month-to-Month'

SELECT
customerID,
Churn,
Contract,
tenure,
TenureBucket,
InternetService,
MonthlyCharges,
TotalCharges,
NumAddOns,
PaymentMethod
FROM
churn_customer
WHERE
Churn = 'NO' AND TenureBucket = '01. 0-12 Months'

SELECT
customerID,
Churn,
Contract,
tenure,
TenureBucket,
InternetService,
MonthlyCharges,
TotalCharges,
NumAddOns,
PaymentMethod
FROM
churn_customer
WHERE
Churn = 'NO' AND SeniorCitizen = 1
   

SELECT
customerID,
Churn,
Contract,
tenure,
TenureBucket,
InternetService,
MonthlyCharges,
TotalCharges,
NumAddOns,
PaymentMethod
FROM
churn_customer
WHERE
Churn = 'NO' AND InternetService = 'Fiber Optic'

SELECT
customerID,
Churn,
Contract,
tenure,
TenureBucket,
InternetService,
MonthlyCharges,
TotalCharges,
NumAddOns,
PaymentMethod
FROM
churn_customer
WHERE
Churn = 'NO' AND PaymentMethod = 'Electronic check'

-- high risk customers

CREATE VIEW High_Risk_Customers AS
SELECT
customerID,
Churn,
Contract,
tenure,
TenureBucket,
InternetService,
MonthlyCharges,
TotalCharges,
NumAddOns,
PaymentMethod
FROM
churn_customer
WHERE
Churn = 'NO' AND Contract = 'Month-to-Month' AND TenureBucket = '01. 0-12 Months' AND InternetService = 'Fiber Optic' AND PaymentMethod = 'Electronic check'