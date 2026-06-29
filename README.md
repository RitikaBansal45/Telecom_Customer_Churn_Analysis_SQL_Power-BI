# Telecom Customer Churn Analysis  

## Overview 
A telecom company was losing customers without knowing which profiles were most at risk. With a 26% churn rate discovered during analysis, the business needed to pinpoint the combination of contract type, service, and payment behaviour most predictive of churn — and create an actionable customer list for the retention team.

## Tools & Technologies 
1.	SQL (MS SQL Server) - 
  •	Data cleaning (NULL imputation)	
  •	ALTER TABLE + UPDATE (derived columns)	
  •	CASE expressions for bucketing
  •	Aggregate churn rate by segment	
  •	Multi-condition filtering	
  •	CREATE VIEW for high-risk list
2.	Power BI
  •	DAX
  •	Drill through

## Business Questions Answered 
1. What is the overall churn rate and revenue impact?
2. Which contract types, internet services and payment methods drive the highest churn?
3. Which currently active customers are at the highest risk of churning?
4. What is the quantified revenue at risk from high-risk customers?
  
## Key Queries Performed
•	Overall churn rate (26% confirmed)
•	NULL audit and imputation (TotalCharges fix)
•	Derived columns: TenureBucket, ChurnFlag, NumAddons, ChargesBucket
•	Churn rate by: Contract, Gender, SeniorCitizen, Partner, PaymentMethod, TenureBucket, InternetService, NumAddons
•	High_Risk_Customers view: Month-to-Month + Fiber Optic + 0-12 months + Electronic Check

## Key Findings
•	26% overall churn rate — 1 in 4 customers leaving
•	Month-to-Month contracts had a 42% churn rate vs 2.8% for two-year contracts
•	Fiber Optic internet users churned at nearly double the rate of DSL users
•	Electronic check payers were the highest-churn payment segment
•	Customers with 0 add-on services churned at 65% — add-ons correlate strongly with retention
•	182 currently active customers match all 4 high-risk signals

## Recommendations
•	Offer incentives (discount/upgrade) to Month-to-Month customers to convert to annual plans
•	Investigate Fiber Optic service quality — possible satisfaction issue driving churn
•	Promote auto-pay or credit card payment methods to Electronic Check users
•	Bundle add-ons in onboarding packages — customers with 3+ add-ons rarely churn
