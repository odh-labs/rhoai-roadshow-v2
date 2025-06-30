# 🧠 RAG GenAI Demo with Docling, Milvus Lite, and MinIO

This project demonstrates an end-to-end **Retrieval-Augmented Generation (RAG)** workflow using only local and open-source tools. It is designed as a clear, modular exercise that walks through every stage of the pipeline:

- Extracting documents from object storage (MinIO)
- Chunking documents into semantically meaningful units (Docling)
- Generating vector embeddings (SentenceTransformers)
- Storing and querying these embeddings (Milvus Lite)
- Augmenting a Large Language Model (LLM) with retrieved context

---

## 🔧 Technologies Used

- **MinIO** – Local S3-compatible object storage for source PDFs
- **Docling** – Intelligent document chunker for structured and unstructured formats
- **SentenceTransformers** – Embedding model for generating dense vectors
- **Milvus Lite** – Embedded vector database using SQLite backend
- **OpenAI / LLM** – To generate answers based on retrieved chunks

---

## 🧪 Exercise Goal

This repository is designed as a learning and prototyping tool for building GenAI systems with structured vector search pipelines. It demonstrates how to:

1. Pull a document from MinIO (`source-docs`)
2. Chunk the document into usable context windows
3. Convert each chunk to a dense vector
4. Store those vectors in Milvus Lite
5. Run a query → perform vector search → get relevant chunks
6. Use those chunks to prompt an LLM for grounded answers

---

## 📁 Folder Layout

.
├── downloads/ # PDF pulled from S3
├── chunks/ # Output of Docling chunker
├── embeddings/ # JSON with embeddings and text
├── requirements/ # Pip requirements per step
├── 00-shakeout.ipynb
├── 01-download-from-s3.ipynb
├── 02-docling-chunker.ipynb
├── 03-embed-chunks.ipynb
├── 04-store-in-milvus.ipynb
├── 05-query-milvus.ipynb
├── 06-generate-answer.ipynb
└── README.md

---


---

## ✅ Why Milvus Lite?

This project uses **Milvus Lite** instead of a remote vector DB server for simplicity. It stores all data locally using SQLite, requiring **no external services or Docker** to run vector search. This makes it ideal for:

- Demos and experimentation
- Teaching RAG concepts
- Running on laptops or edge devices

---

## 🏁 Next Steps

See each script in order (`01-` through `06-`) and refer to the detailed `README.md` included with the pipeline for setup instructions, requirements, and expected outputs.

You can also swap out components (e.g. embedding model, LLM, or use FAISS instead of Milvus) to extend the architecture.

---

## 👥 Acknowledgements
TBC
