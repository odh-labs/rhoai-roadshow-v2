# Data Engineering with Elyra Pipelines on OpenShift AI

## Why do customers care?

### Situation  
Data is the heart of AI and (naturally) data analytics. However, it is rarely available in a clean, analysis-ready format. Customers frequently need to acquire data from multiple sources, perform preprocessing (e.g., date normalisation, column removal), and store results in cloud-compatible formats such as Parquet or CSV in object storage.

### Complication  
Manually managing these workflows in notebooks or scripts is error-prone and difficult to scale or repeat. Data Engineers want automated, repeatable pipelines to clean and merge datasets using modern data engineering best practices.

Many organisations also struggle to adopt structured pipelines for preprocessing and ETL. They require examples that integrate Git-based version control, pipelines as code, and storage solutions to make these workflows production ready.

## Why does Red Hat care?

### Situation  
Red Hat provides platforms (OpenShift) and tools (OpenShift AI with Elyra, Pipelines, and S3-compatible storage) to enable repeatable, portable, and scalable data engineering workflows. We need to show how OpenShift AI provides a platfor that unifies the tools and activies and ultimately simplifies the work. 

### Complication  
??? 

## What is it?

This module demonstrates a practical example of a data engineering task built with Elyra Pipelines and executed in Jupyter notebooks.

It enables:
- Git-based input data sourcing
- Preprocessing with notebook steps for column dropping and date reformatting
- Merging datasets into a single DataFrame
- Uploading final output to S3-compatible storage
- All orchestrated using Elyra visual pipelines

## How do we do it?

1. Use Elyra’s pipeline visual editor in JupyterLab to define each stage as a notebook node.  
2. Clone CSV files from a public Git repository into the notebook environment.  
3. Run data-preparation notebooks that:
   - Reformat a date column from `m/d/y` to `d/m/y`  
   - Drop unnecessary columns  
   - Merge two datasets using the date as the common key
4. Store the merged result in a remote S3 bucket using the `boto3` Python library.  
5. Execute the pipeline using OpenShift AI's notebook server environment.

## Delivery Format

All exercises are written as Jupyter Notebooks with clear cell-by-cell instructions and will be linked together using Elyra Pipelines. Each notebook will perform a self-contained data engineering task and be part of a visual workflow.

## Roadshow workshop narrative

1. Introduce the need for scalable and reproducible data engineering workflows.  
2. Describe the limitations of one-off script-based data cleaning.  
3. Show how Elyra Pipelines improve reusability, modularity, and visibility.  
4. Walk through downloading CSV files from a Git repository.  
5. Demonstrate how to clean, reformat, and join the datasets.  
6. Export the merged dataset to S3 for downstream consumption.  

## Hands-on lab

1. Run a setup notebook that checks access to Git, S3, and validates required Python packages.  
2. Notebook 1: Clone CSV files from a GitHub repository and load them into pandas DataFrames.  
3. Notebook 2: Convert a date column from `m/d/y` format to `d/m/y`.  
4. Notebook 3: Drop a specified column from each dataset.  
5. Notebook 4: Merge the cleaned datasets using a common column.  
6. Notebook 5: Save the merged result to S3 using AWS-compatible credentials.  
7. Create and execute the Elyra Pipeline by linking these notebooks as sequential steps.

Notes:
1. Probably need to schedule a pipeline as well.
2. Do we need to set up the workbench to add data connections etc?
