# Introduction

Let's explore the LLamaStack playground application first. This is a [Streamlit](https://streamlit.io/) built application that allows you to explore your LLamaStack deployment. You should be able to browse and login here.

<a href="https://llama-stack-playground-llama-stack.apps.<CLUSTER_DOMAIN>" target="_blank">LLamaStack playground</a>

## LLamaStack

[LLamaStack](https://llama-stack.readthedocs.io/en/latest/) is the open-source framework for building generative AI applications. We have a LLamaStack server configured for our use and we are going to take a look around using the playground UI.

If you are interested in how to configure LLamaStack, check out the [docs](https://llama-stack.readthedocs.io/en/latest/) and you can also take a look at the running config in your cluster:

<a href="https://console-openshift-console.apps.<CLUSTER_DOMAIN>/k8s/ns/llama-stack/configmaps/llama-stack-config" target="_blank">ConfigMap llama-stack-config</a>

## Models

We have four models configured in LLamaStack. Three of them are available to `Chat` to, i.e., are type `llm` in the model dropdown. The other model is an `embedding` model used to create vector embeddings for RAG.

```yaml
models:
- metadata: {}
  model_id: ${env.LLAMA3B_MODEL}
  provider_id: llama-3b
  model_type: llm
- metadata: {}
  model_id: ${env.DEEPSEEK_MODEL}
  provider_id: deepseek
  model_type: llm
- metadata:
    embedding_dimension: 384
  model_id: all-MiniLM-L6-v2
  provider_id: sentence-transformers
  model_type: embedding
- metadata: {}
  model_id: llama-4-scout-17b-16e-w4a16
  provider_id: vllm-llama-4-guard
  provider_model_id: llama-4-scout-17b-16e-w4a16
  model_type: llm
```

![images/model-intro.png](images/model-intro.png)

The *llama-3* and *deepseek* models are running locally in the OpenShift cluster - they are small in terms of parameter size (3b and 8b) and the DeepSeek model is quantized to 4-bit. This reduces the amount of memory they consume on the GPU. Even so we are using 18Gi of nvram to run the LLM's. If you browse to the <a href="https://console-openshift-console.apps.<CLUSTER_DOMAIN>/k8s/ns/llama-serving/core~v1~Pod" target="_blank">Deepseek Pod</a> enter the `Terminal` and run `nvtop` on the command line to see the GPU performance.

The *llama-4 scout* model is running in a Model as a Service (MaaS) externally to the cluster. It is a much larger LLM (17b), but still quantized (w4a16).

![images/model-gpu.png](images/model-gpu.png)

## Chat

You can chat with either of the three LLM models. You should note that the llama-3 model is an [instruction tuned model](https://huggingface.co/meta-llama/Llama-3.2-3B) whilst the deepseek model is a [reasoning model](https://huggingface.co/unsloth/DeepSeek-R1-0528-Qwen3-8B-bnb-4bit). Deepseek will produce reasoning tokens (between \<think\>) where it will try to break a problem down into steps prior to generating output tokens.

![images/chat-intro.png](images/chat-intro.png)

The llama-4 model running in MaaS is a RedHat validated model and is a [Mixture of Experts (MoE)](https://huggingface.co/blog/moe) model - you can see the RedHat validated models on [RedHatAI Hugging Face](https://huggingface.co/RedHatAI/Llama-4-Scout-17B-16E-Instruct-quantized.w4a16)

## RAG

LLamaStack is configured to use an inbuilt version of the [Milvus vector database](https://llama-stack.readthedocs.io/en/latest/providers/vector_io/milvus.html) for Retrieval Augmented Generation (RAG).

```yaml
  vector_io:
  - provider_id: milvus
    provider_type: inline::milvus
    config:
      db_path: ${env.MILVUS_DB_PATH}
```

If you want, you can try it out by uploading a TXT, PDF, DOC, DOCX document, then `Create Document Collection` and use it for RAG.

![images/rag-intro.png](images/rag-intro.png)

I uploaded the famous [**bitcoin.pdf**](https://bitcoin.org/bitcoin.pdf) document from Satoshi 🤑

Note that the context sizes (max tokens) for the models are set as follows, so use the Llama4 model for best results (you may get errors depending on your document size).

```yaml
Llama3:    15000
DeepSeek:  10000
Llama4:    110000
```

## Tools, Agents and MCP Servers

We are going to deep dive into Agents and Tools, Model Context Protocol servers (MCP) in this section and see how we can create and use them. 

The LLamaStack playground is configured for many tools - for example check the ConfigMap for tool_groups.

```yaml
tool_groups:
- provider_id: tavily-search
  toolgroup_id: builtin::websearch
```

You can select tools and agents in the playground.

![images/tools-intro.png](images/tools-intro.png)

For example, select the `weather` MCP server, LLama model and Regular agent - and try asking for the weather in New York today

![images/weather-tool.png](images/weather-tool.png)
