# RAG Module – Document Ingestion  
Prepare enterprise documents for Retrieval-Augmented Generation by converting PDFs to text, creating embeddings, and loading them into Milvus on OpenShift AI. :contentReference[oaicite:0]{index=0}

## What is it?
This notebook is the first step in the RAG lab series. It shows you how to:  
* connect to a MinIO/S3 object store and retrieve a PDF,  
* parse the PDF into clean, chunk-sized text with **Docling**,
* generate 1 536-dimension semantic embeddings using the `text-embedding-3-small` model from OpenAI, and  
* store those embeddings in a **Milvus** vector collection for similarity search. :contentReference[oaicite:1]{index=1}

## Why it’s important
Efficient document ingestion is the foundation of any RAG pipeline: without high-quality chunks and embeddings, downstream retrieval will be slow, inaccurate, or both. Automating this step inside an OpenShift AI workspace lets data scientists repeat the process for thousands of PDFs while keeping sensitive content inside the cluster. :contentReference[oaicite:2]{index=2}

## Hands-on Lab
Follow the notebook to complete the workflow end-to-end.

You will learn  
- ✅ **Workspace setup** – export the environment variables `OPENAI_API_KEY`, `AWS_S3_ENDPOINT`, `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_DEFAULT_REGION`, and `AWS_S3_BUCKET`. :contentReference[oaicite:3]{index=3}  
- ✅ **Download a document** – use `boto3` to copy `2502.07835v1.pdf` from MinIO to your local `downloads/` directory. :contentReference[oaicite:4]{index=4}  
- ✅ **Parse & chunk** – convert the PDF into structured pages and text segments with `DocumentConverter`. :contentReference[oaicite:5]{index=5}  
- ✅ **Generate embeddings** – wrap the OpenAI API in a helper function and confirm the embedding dimension. :contentReference[oaicite:6]{index=6}  
- ✅ **Create a vector store** – initialise a Milvus collection with matching dimensions and insert the embeddings. :contentReference[oaicite:7]{index=7}  
- ✅ **Verify ingestion** – inspect the collection and run a sample query to ensure your vectors are searchable.

> **Estimated time:** 15 – 20 minutes  
> **Prerequisites:** An OpenShift AI Workbench project with network access to both OpenAI and your MinIO instance, plus a valid OpenAI API key.

Once completed, your PDF is available for low-latency, semantic retrieval in the subsequent RAG Question-Answering notebook.
