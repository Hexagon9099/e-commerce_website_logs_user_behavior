-- This query detects 3 different criteria of suspicious activity.
  -- Criteria 1. IPs with frequency requests more than 3 times during 1 second
  -- Criteria 2. IPs that use all 3 unique account types per day
  -- Criteria 3. IPs with session durations and data consumption greater than 75% of users, exhibiting repeated behavior more than once.
-- If all 3 criteria are fulfilled, the IP address is considered fraudulent.


{{ config(materialized='table') }}

-- Criteria 1.
WITH request_frequency AS(
SELECT
  ip,
  COUNT(*) AS request_count,
  TIMESTAMP_TRUNC(accessed_date, SECOND) AS time_window
FROM `de-projects-453518.web_logs_dataset.web_logs`
GROUP BY 1,3
HAVING request_count >= 3
ORDER BY request_count DESC
),
-- Criteria 2.
account_usage AS(
SELECT 
  ip,
  DATE(accessed_date) AS request_date,
  COUNT(DISTINCT account_type) AS unique_accounts,
  COUNT(*) AS total_requests
FROM `de-projects-453518.web_logs_dataset.web_logs`
GROUP BY ip, request_date
HAVING unique_accounts > 2
ORDER BY total_requests DESC),
-- Criteria 3.
session_behavior AS(
WITH quatiles AS(
  SELECT
    APPROX_QUANTILES(duration_sec, 100)[OFFSET(75)] AS q75_duration,
    APPROX_QUANTILES(bytes, 100)[OFFSET(75)] AS q75_bytes
  FROM `de-projects-453518.web_logs_dataset.web_logs`
)
SELECT
  ip,
  bytes,
  q75_bytes,
  q75_duration,
  ROUND(AVG(duration_sec)) AS avg_session_duration,
  COUNT(*) AS session_count
FROM `de-projects-453518.web_logs_dataset.web_logs`, quatiles
GROUP BY ip, bytes, q75_bytes, q75_duration
HAVING avg_session_duration >q75_duration AND bytes>q75_bytes
  AND session_count>1
ORDER BY session_count DESC
)
-- Uniting results where all 3 criteria are fulfilled.
SELECT
  rf.ip,
  MAX(rf.request_count) AS requests_per_second,
  MAX (au.total_requests) AS requests_per_day_from_3_account_types,
  MAX (sb.session_count) AS sessions_q75_duration_bytes
FROM request_frequency rf
JOIN account_usage au ON rf.ip = au.ip
JOIN session_behavior sb ON rf.ip = sb.ip
GROUP BY rf.ip
ORDER BY requests_per_second DESC