-- This model analyzes user segmentation by RFM category across different countries.
-- It provides:
    -- The distribution of user segments (high, mid, low) by country.
    -- The average age of users within each segment and country.
    -- The gender breakdown within each segment and country.

{{ config(materialized='table') }}

WITH user_attributes AS (
  SELECT 
    ip,
    ARRAY_AGG(country ORDER BY accessed_date DESC LIMIT 1)[SAFE_OFFSET(0)] AS country,
    ARRAY_AGG(age ORDER BY accessed_date DESC LIMIT 1)[SAFE_OFFSET(0)] AS age,
    ARRAY_AGG(gender ORDER BY accessed_date DESC LIMIT 1)[SAFE_OFFSET(0)] AS gender
FROM {{source('source_bq', 'web_logs')}} 
GROUP BY 1
),
user_data AS(
SELECT
  rfm.ip,
  ua.country,
  ua.age,
  ua.gender,
  rfm.user_value
FROM {{ref('RFM_analysis')}} rfm 
LEFT JOIN  user_attributes ua
ON rfm.ip = ua.ip
),
percentage AS (
SELECT
  country,
  user_value,
  COUNT (*) AS count_users,
  SUM (COUNT (*)) OVER (PARTITION BY country) AS total_users_per_country,
  ROUND ((COUNT (*) / SUM (COUNT (*)) OVER (PARTITION BY country) *100), 2) AS percentage
FROM user_data
GROUP BY country, user_value
ORDER BY country
),
aggregations AS(
SELECT
 country,
 user_value,
  ROUND (AVG (age), 2) AS avg_age,
  ROUND (SUM (CASE WHEN gender = 'Male' THEN 1 END) / COUNT (CASE WHEN gender IS NOT NULL THEN 1 END) *100, 2) AS percentage_male,
  ROUND (SUM (CASE WHEN gender = 'Female' THEN 1 END) / COUNT (CASE WHEN gender IS NOT NULL THEN 1 END) *100, 2) AS percentage_female
FROM user_data 
GROUP BY country, user_value 
ORDER BY country
)
SELECT 
  p.country,
  p.user_value,
  p.percentage AS user_value_share_per_country,
  a.avg_age,
  a.percentage_male,
  a.percentage_female
FROM percentage p
JOIN aggregations a
USING (country, user_value)
ORDER BY 1
