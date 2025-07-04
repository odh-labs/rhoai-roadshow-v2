# RAG with OpenShift AI

## Why do customers care ?

### Situation
Customers are adopting GenAI to improve operational efficiency, automate tasks, and unlock insights from internal data.

### Complication
However, out-of-the-box LLMs do not have knowledge of an organisation’s private documents, internal systems, or current operational data. They also suffer from fixed knowledge cutoff and cannot access proprietary or up-to-date information. Therefore, outside of general knowledge, their usefulness is very limited for meaningful business-specific queries, compliance reporting, and domain-specific tasks.  

Retraining or fine tuning models to include internal data is expensive, slow, and generally impractical. Organisations want a way to enrich LLMs with their internal data without retraining.

## Why does Red Hat care ?
### Situation:
Red Hat provides platforms, software infrastructure and tools for building scalable and secure AI solutions: 
* OpenShift being a high-productivity platform for COTS and bespoke applications that you can host supporting components such as vector databases.
* OpenShift AI provides a high-productivity platform for developing and serving AI applications and models.

Red Hat is uniquely positioned in having the single completely integrated stack to build end to end solutions.

### Complication:
OpenShift AI is excellent at "engineering a solution," it is not great at "assembling a solution." RAG workloads introduce new infrastructure requirements: vector databases, embedding pipelines, secure document handling, and scalable inference runtimes that all need to be individually pieced together. These workloads require orchestration and observability across multiple components.

Our customers need more cookie-cutter examples of how to build this pattern quickly and focus on writing business logic.

## What is it ?

RAG (Retrieval-Augmented Generation) is a GenAI pattern that improves the relevance and accuracy of model responses by incorporating external knowledge retrieved at inference time.

It allows:  
* Queries to be enriched with up-to-date or proprietary information stored in document or knowledge stores.  
* Embedding models to convert documents and queries into vector space for similarity search.  
* LLMs to generate responses that are grounded in retrieved, relevant documents.  
* RAG avoids retraining by dynamically retrieving and injecting relevant content into prompts at runtime.  

## How do we do it ?
1. Use OpenShift AI to orchestrate embedding models (e.g. Sentence Transformers or Hugging Face models) for document indexing.  
2. Store vectorised embeddings in a vector database such as Milvus or Weaviate, deployed with OpenShift Data Science tooling.  
3. Serve LLMs (e.g. vLLM with Granite or Mistral) using KServe for scalable inference.
4. Build a front-end or API that handles the retrieval and augmentation workflow, submitting a query, retrieving top-K similar embeddings, and composing an augmented prompt for the LLM.

## Delivery Format
Lab will be delivered through an intro page in the workshop web site and the activites will be documented in a Jupyter Notebook for each subsection.

## Roadshow workshop narrative
1. Outline the limitations of LLMs and knowledge cutoff and business domain knowledge.
2. Describe how we can provide additional context to our queries by providing documents as well.
3. Explain why it is impractical to provide the whole document as context.
4. Decribe the role of vector databases and embedding models
5. Demonstrate a solution without RAG
6. Demonstrate how to populate the vector database
7. Demonstrate a solution with RAG (with good context prompt and bad prompt)

## Hands-on lab
1. Run a lab shakeout script to verify connectivity to model server, vector DB, object store and model-car registry.  
2. Review a document that we will insert into the RAG pipeline (e.g. a policy doc, FAQ, product manual).  
3. Ask a question without using RAG and observe the generic or inaccurate response.  
4. Feed the document into an embedding model and store embeddings in a vector DB (e.g. Milvus).  
5. Run a sample app that performs similarity search and constructs an augmented prompt.  
6. Ask the same question again and observe the improved, grounded response using RAG.  
7. (Optional) Enable multi-user access or workspace isolation for embeddings to demonstrate tenant separation.  
8. (Optional) Visualise vector space using dimensionality reduction (e.g. UMAP or PCA) for understanding.  

### Alternative Idea:
1. AnythingLLM to test queries with no RAG  
2. We use Docling to import  
3. Recofigure AmythingLLM for RAG to perform the RAG

### Workshop example
https://ragit.dev/ 
