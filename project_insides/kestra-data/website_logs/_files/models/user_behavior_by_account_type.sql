-- The model calculates business indicators for each type of account:
    -- LTV (Lifetime value). The average revenue per user over the entire lifecycle of a user.
    -- ARPU (Average revenue per user). Average revenue per user per day.
    -- Retention rate. The percentage of users who return to the site within 7 days of their first login. 
    -- Refund rate. The share of returned funds among the revenue.
-- Fraudulent traffic is excluded for the purity of statistics.
 

{{ config(materialized='table') }}

WITH user_attributes AS(
  SELECT
    ip,
    ARRAY_AGG(accessed_date ORDER BY accessed_date DESC LIMIT 1)[SAFE_OFFSET(0)] AS last_accessed_date,
    ROUND(AVG(duration_sec),2) AS avg_duration,
    ROUND(AVG(bytes),2) AS avg_bytes,
    ARRAY_AGG(account_type ORDER BY accessed_date DESC LIMIT 1)[SAFE_OFFSET(0)] AS last_account_type,
    ROUND(AVG(sales),2) AS avg_sales,
    ROUND(AVG(refunded_amount),2) AS avg_refunded_amount,
    ARRAY_AGG(payment_method ORDER BY accessed_date DESC LIMIT 1)[SAFE_OFFSET(0)] AS last_payment_method
  FROM {{source('source_bq', 'web_logs')}}
  GROUP BY 1
),
user_revenue AS (
  SELECT
    rfm.ip,
    ROUND(SAFE_DIVIDE(SUM(rfm.spent_per_week) / 7, COUNT(rfm.ip)),2) AS ARPU_per_day,
    COUNT(DISTINCT DATE(accessed_date)) AS active_days,
    ROUND(SAFE_MULTIPLY(SAFE_DIVIDE(SUM(rfm.spent_per_week) / 7, COUNT(rfm.ip)), COUNT(DISTINCT DATE(accessed_date))),2) AS LTV
  FROM {{source('source_bq', 'web_logs')}} wl
  RIGHT JOIN {{ref('RFM_analysis')}} rfm
  ON wl.ip = rfm.ip
  GROUP BY 1
  ORDER BY 2 DESC
),
first_visit AS(
  SELECT
  ip,
  MIN(DATE(accessed_date)) AS first_visit
  FROM {{source('source_bq', 'web_logs')}}
  GROUP BY 1
),
retention AS(
  SELECT
    fv.ip,
    fv.first_visit,
    DATE_DIFF(DATE(wl.accessed_date), fv.first_visit, DAY) AS day_number,
    COUNT(DISTINCT fv.ip) AS retained_users
  FROM {{source('source_bq', 'web_logs')}} wl
  JOIN first_visit fv
  ON wl.ip = fv.ip
  GROUP BY 1,2,3
)
SELECT 
  DISTINCT ua.last_account_type AS account_type,
  COUNT (ua.ip) AS total_accounts,
  ROUND(AVG(ur.LTV),2) avg_LTV,
  ROUND(AVG(ur.ARPU_per_day),2) AS ARPU_per_day,
  ROUND(SAFE_DIVIDE(COUNT(DISTINCT CASE WHEN r.day_number IN (1,2,3,4,5,6,7) THEN r.ip END), COUNT(DISTINCT r.ip))*100, 2) AS retention_rate_per_week,
  ROUND(SAFE_DIVIDE(SUM(ua.avg_refunded_amount) * 100, SUM(ua.avg_sales)),2) AS refund_rate
FROM user_attributes ua
RIGHT JOIN user_revenue ur
ON ua.ip = ur.ip
LEFT JOIN retention r
ON ur.ip = r.ip
GROUP BY 1