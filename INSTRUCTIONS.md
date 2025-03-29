# Instructions how to run this project
Execute the project in the terminal while in the root directory of this project.


## Prerequisites:
- Docker installed
- Active GCP account (free version is enough)



## Step 1. GCP project and service account setup.

If you have a GCP project, service account (with "BigQuery Admin" and "Storage Admin" roles) and its credentials ready to use, you can skip this step. Otherwise

1.1. Go to [GCP console](https://console.cloud.google.com/) \
1.2. Choose a GCP project where you want to implement this GitHub project in (1). You can either create a new project (2.1) or choose an existing one (2.2). Note that we will need project ID (3) in the 2.2 clause, which you can extract from here. \
   ![step 1.2 image](https://i.imgur.com/TEaJC5Q.jpeg) \
1.3. Click on "Navigation menu" (number 4 on the screenshot above), then go to "IAM and Admin" (5) -> "Service accounts" (6). Click on "Create service account" (7).
   ![step 1.3 image](https://i.imgur.com/s1CUgcm.jpeg) \
1.4. Put any service account name you want (8) and click "Create and continue" (9)
   ![step 1.4 image](https://i.imgur.com/lIcaYky.jpeg) \
1.5. Add 2 roles (10): "BigQuery Admin" and "Storage Admin" for managing resources in data warehouse (BigQuery) and a datalake \
   (Google Cloud Storage). Click "Continue" (11) \
   ![step 1.5 image](https://i.imgur.com/dgIStzE.jpeg) \
1.6. Skip the next step by clicking "Done" \
1.7. Next to the just-created service account, click (12) and (13). \
   ![step 1.7 image](https://i.imgur.com/FOe6HK9.jpeg) \
1.8. "Add key" (14) -> "Create new key" (15, not shown on the screenshot). Leave the suggested JSON format and click "Create" (16) \
   ![step 1.8 image](https://i.imgur.com/xoaDHSv.jpeg) \
   A JSON key was downloaded on your machine. You can put it anywhere you want. We will need the content of this file in the next step.


## Step 2. Filling in GCP credentials for the project
2.1. Open the [1_gcp_kv.yml](workflows/1_gcp_kv.yml) workflow with any IDE (e.g. VS Code). The file is located at `workflows/1_gcp_kv.yml` \
2.2. Replace the rows from `12` to `24` (included) with the content of your GCP credentials file, extracted in 1.8 clause. \
2.3. Replace the value in row `31` with your GCP project ID, which you can find in the 1.2 clause. \
2.4. Come up with a GCS bucket name and replace the value in row `45`. You can put any name you come up with, but it has to be globally unique, so I recommend using your project ID and several random digits after it as shown in the example. \
2.5. Save the [1_gcp_kv.yml](workflows/1_gcp_kv.yml) file and open [schema.yml](workflows/schema.yml), located at `workflows/schema.yml` \
2.6. Replace the content of row 5 with your GCP Project ID, which we have already specified in the 2.3 clause. \
2.7. Save and close the [schema.yml](workflows/schema.yml) file. Don't change anything else in this file besides the action in the 2.6 clause for the project to run smoothly. \
2.8. Open a terminal in the root directory of this project. Execute the command \
      `cp ./workflows/schema.yml ./project_insides/dbt/web_logs/models/schema.yml` 


## Step 3. Executing workflows
3.1. Open "Docker Desktop" on your machine, or launch the Docker engine in any other way. \
3.2. In your terminal (assuming you're in the root directory of this project), execute the following commands: \
   `docker volume create spark-data` \
   `docker-compose up -d` \
3.3. In any browser, go to [localhost:8080](http://localhost:8080/). Now you see Kestra UI. \
3.4. Click on "Flows" (17), then "Import" (18) \
   ![step 3.4 image](https://i.imgur.com/tpQwtwM.jpeg) \
3.5. Import all the 3 workflows located at the `workflows` folder. \
     The files are: [1_gcp_kv.yml](workflows/1_gcp_kv.yml), [2_gcp_setup.yml](workflows/2_gcp_setup.yml), [3_ETL_end_to_end_pipeline.yml](workflows/3_ETL_end_to_end_pipeline.yml) \
3.6. Now you see them in Kestra UI, in the "Flows" section: \
   ![step 3.6 image](https://i.imgur.com/ips8dKz.jpeg) \
3.7. Run them in order. Click on each workflow name (19.1, 19.2, 19.3) and then on the Execute button (20). Repeat the action for all 3 workflows. \
   ![step 3.7 image](https://i.imgur.com/zCXZzq4.jpeg) \
   Congratulations! The project has been successfully executed. \
   If you encounter any issues, feel free to report them in the [Issues](https://github.com/Hexagon9099/website_logs/issues) section of this repository.


## Step 4. Exploring the project results 
4.1. The project's dashboard is constructed in Looker Studio and available [here](https://lookerstudio.google.com/s/quHfV4HKzzA). \
   If you want to explore deeper, you can check on the tables created in BigQuery, by following the steps described in  clauses. \
4.2. Go to [GCP console](https://console.cloud.google.com/) \
4.3. Click on "BigQuery" (21) \
   ![step 4.3 image](https://i.imgur.com/fUHn65J.jpeg) \
4.4. The tables created (24) are located under your project name (22) and dataset name (23). \
   ![step 4.4 image](https://i.imgur.com/MyKyVcl.jpeg) \
 The tables are:
 - 24.5 "web_logs". Marketplace website logins for the period from 14.03.2025 to 21.03.2025
 - 24.1-24.4. You can find the description of these tables in [schema.yml](workflows/schema.yml) file \
 The column description is available in "Schema" of every table.

   

