# Simple RAG (Retrieval-Augmented Generation) Implementation

In this module, you'll bring together all the key components of a Retrieval-Augmented Generation (RAG) solution. Using Docling to parse and chunk documents, Milvus as the vector database, and a GenAI model to generate responses, you'll build a working RAG pipeline end-to-end.

## Learning Objectives

By the end of this notebook, you will understand:

1. **Document Ingestion**: How to download and process documents from object storage
2. **Text Embeddings**: How to convert text into numerical vectors for semantic search
3. **Vector Databases**: How to store and query embeddings efficiently using Milvus
4. **Retrieval Process**: How to find relevant document chunks based on user queries
5. **Augmented Generation**: How to combine retrieved context with LLMs for accurate responses

## What is RAG?

**Retrieval-Augmented Generation (RAG)** is a powerful technique that combines the strengths of:

- **Information Retrieval**: Finding relevant documents from a knowledge base
- **Generative AI**: Using Large Language Models to generate human-like responses

### Why Use RAG?

- **Up-to-date Information**: Access to current documents beyond the LLM's training data
- **Reduced Hallucinations**: Grounding responses in factual, retrieved content
- **Domain-Specific Knowledge**: Incorporate specialized documents and expertise
- **Transparency**: See exactly which documents informed the response

### The RAG Pipeline

```bash
Query → Embedding → Vector Search → Context Retrieval → LLM Generation → Response
```

## Architecture Overview

This implementation demonstrates a simple but complete RAG system:

1. **Document Storage**: MinIO/S3 object storage for source documents
2. **Text Processing**: Docling for PDF parsing and chunking
3. **Embeddings**: SentenceTransformers for converting text to vectors
4. **Vector Database**: Milvus for storing and searching embeddings
5. **LLM Integration**: Llama model for generating responses

From the rhoai-roadshow-v2/lab-materials/2-rag folder, please open the notebook called: <a href="https://github.com/odh-labs/rhoai-roadshow-v2/blob/main/docs/2-rag/notebook/4-simple-rag.ipynb" target="_blank">4-simple-rag.ipynb</a>

When done, you can close the notebook and head to the next page.
