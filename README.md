# E-commerce website logs analysis | Data Engineering GCP project

## Introduction
I built an end-to-end pipeline for E-commerce website logs, focusing on fraud detection, user behavior, and segmentation analysis. The batch process runs on a weekly schedule, leveraging GCP (GCS, BigQuery), Spark, dbt, Docker, Looker, and Kestra to filter fraudulent traffic, segment users via RFM analysis, and assess membership impact. The results: improved data integrity by eliminating fraudulent traffic, enhanced user analytics through precise segmentation, and optimized engagement strategies that drive retention and revenue growth.

## Problem description
The website faced challenges with fraudulent traffic and inefficient user segmentation, leading to poor analytics and revenue loss. This project implemented a robust fraud detection system and refined user segmentation, ensuring accurate insights and optimized targeting strategies.

## Architecture
![data architecture](project_insides/Data_architecture.png)

## Technology used
1. Programming Language – Python
2. Query Language – SQL
3. Cloud Platform – Google Cloud Platform (GCP)
   - BigQuery
   - Google Cloud Storage (GCS)
   - Looker Studio
4. Data Processing & Transformation – Apache Spark, dbt
5. Workflow Orchestration – Kestra
6. Environment Management – Docker
7. Metadata & Workflow Storage – PostgreSQL (for Kestra)

## Running this project
To run the project, go to [instructions](INSTRUCTIONS.md). The instructions are beginner-friendly, so you will be able to run the project even if you have no experience with the mentioned technologies.

## Results
1. [Dashboard](https://lookerstudio.google.com/s/quHfV4HKzzA) in Looker Studio. Here you will find the analysis results and business recommendations.
2. BigQuery. If you have run the project, the transformed data will be available in your BigQuery instance for deeper exploration.

See step 4 in the [instructions](https://github.com/Hexagon9099/website_logs/blob/main/INSTRUCTIONS.md#step-4-exploring-the-project-results) for guidance on exploring the results.

## Detailed project description (optional)
### Fraud Detection & Security Analysis 🕵️‍♂️
**Question**: _How can we systematically detect and eliminate fraudulent traffic to ensure data integrity?_

🚨 Advanced Fraud Detection System – I implemented a robust multi-layered detection model to identify and filter out suspicious activity, ensuring only legitimate user data is analyzed.

✅ Triple-Criteria Approach: \
 🔹 High-Frequency Requests – IPs making more than 3 requests per second are flagged as potential bots. \
 🔹 Unrealistic Account Usage – IPs accessing all 3 unique account types in a single day indicate potential credential abuse. \
 🔹 Suspicious Session Behavior – Users with session durations and data consumption in the top 25% of all users, repeating this pattern multiple times, are likely engaging in fraudulent activity. \
🚨 Only those IPs that fulfilled all 3 criteria are considered fraudulent.

💡 _Why It Matters?_ By proactively filtering out fraudulent traffic, I enhance the accuracy of user analytics, prevent revenue loss, and strengthen platform security—making our insights truly data-driven.

### Target Audience & User Segmentation 📊
**Question**: _How can we identify and segment our most valuable users based on their engagement and spending behavior?_

🔹 User Value Segmentation – Implemented RFM (Recency, Frequency, Monetary) analysis classifies users into three value groups: high, mid, and low.  This segmentation helps in understanding user retention, loyalty, and contribution to revenue. \
🔹 Fraud Detection & Data Integrity – To ensure accurate insights, fraudulent traffic was excluded from the analysis, preventing skewed results. \
🔹 Country-Specific Insights – I expanded the segmentation by analyzing user distribution across different countries, calculating the share of each segment, the average age per group, and the gender composition.

💼 This approach enables data-driven decision-making, allowing businesses to focus on high-value users while optimizing engagement strategies for lower-tier segments.

### Membership & User Behavior Analysis 💎
**Question**: _How does membership type (premium vs. free) impact user engagement, revenue, and retention?_

🔹 Account Type Segmentation – Users are segmented by account type (premium, normal, not logged in) to assess key metrics like LTV, ARPU, and retention. \
🔹 Engagement & Revenue Insights – Analyzed average revenue per user and refund rates across account types. \
🔹 Retention Analysis – Calculated weekly retention rates to understand user loyalty and return behavior for each segment.

📈 This approach helps identify key drivers of user value, guiding strategies to enhance engagement and revenue across different membership types

## Code & Configurations (optional)
1. [End-to-end pipeline](workflows/3_ETL_end_to_end_pipeline.yml). This is the major pipeline, which shows you all the details about project inner processes. The visualization of all the processes going on in this pipeline is shown under the "Architecture" section as the contents of the purple dashed rectangle.
2. [dbt models](project_insides/dbt/web_logs/models). A detailed description of each model is available in the [schema](project_insides/dbt/web_logs/models/schema.yml) file. The interaction of these dbt models is shown in the "Architecture" section as the contents of the orange dashed rectangle.
3. [Docker-compose](docker-compose.yml). Docker-compose integrates Spark, Kestra, and Postgres services into a single network, ensuring that this project runs on your machine.The visualization of this integration is shown under the "Architecture" section as the contents of the blue dashed rectangle.
4. [GCP credentials workflow](workflows/1_gcp_kv.yml). An auxiliary workflow that allows you to configure the connection to your GCP.
5. [Infrastructure Automation](workflows/2_gcp_setup.yml). An auxiliary lightweight IaC workflow that automatically creates a GCS bucket and BigQuery dataset for this project.







