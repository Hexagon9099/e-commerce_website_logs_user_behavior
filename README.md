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

## 

This file is under construction. To run the project, go to [instructions](INSTRUCTIONS.md)

