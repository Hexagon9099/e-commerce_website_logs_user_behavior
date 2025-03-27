# Instructions how to run this project
Execute the project in the terminal while in the root directory of this project.


## Prerequisites:
- Docker installed
- Active GCP account (free version is enough)



### Step 1. GCP project and service account setup.

If you have a GCP project, service account (with "BigQuery Admin" and "Storage Admin" roles) and its credentials ready to use, you can skip this step. Otherwise

1.1. Go to [GCP console](https://console.cloud.google.com/) \
1.2. Choose a GCP project where you want to implement this GitHub project in (1). You can either create a new project (2.1) or choose an existing one (2.2). Note that we will need project ID (3) in the future, which you can extract from here. \
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


### Step 2. Filling in GCP credentials for the project
2.1. Open the [1_gcp_kv.yml](1_gcp_kv.yml) workflow with any IDE (e.g. VS Code). The file is located at `workflows/1_gcp_kv.yml` \
2.2. Replace the rows from `11` to `23` (included) with the content of your GCP credentials file, extracted in 1.8 clause. \
2.3. Replace the value in row `30` with your GCP project ID, which you can find in the 1.2 clause. \
2.4. Come up with a GCS bucket name and replace the value in row `44`. You can put any name you come up with, but it has to be globally unique, so I recommend using your project ID and several random digits after it as shown in the example. \
2.5. Save the [1_gcp_kv.yml](1_gcp_kv.yml) file and open [schema.yml](schema.yml), located at `workflows/schema.yml` \
2.6. Replace the content of row 5 with your GCP Project ID, which we have already specified in the 2.3 clause. \
2.7. 



