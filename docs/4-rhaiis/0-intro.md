# RHAIIS - Red Hat AI Inference Server

The modern high performance LLM serving engine - Red Hat AI Inference Server & vLLM.

## What is it?
The Red Hat AI Inference Server is a powerful, enterprise-grade solution for serving large language models. It is built on the open-source vLLM library, a state-of-the-art engine for LLM inference and serving.

At its core, the server is designed to make the process of deploying and running LLMs as efficient as possible. It abstracts away the complexities of the underlying hardware and provides a simple, consistent API for developers to interact with. Red Hat's involvement ensures that the server is well-supported, secure, and can be integrated seamlessly into existing enterprise workflows and platforms like Red Hat OpenShift.

## Why it's important?
In the rapidly evolving world of Generative AI, deploying large language models (LLMs) efficiently is a significant challenge. As models become more powerful, they also become more resource-intensive, leading to high operational costs and slow response times. This is where vLLM and the Red Hat AI Inference Server come in.

The key benefits are:
* **Maximized GPU Utilization** - Traditional inference methods often underutilize expensive GPU resources. The server, powered by vLLM, employs a novel memory management technique called PagedAttention to minimize memory waste and fragmentation. This allows for higher batch sizes and, consequently, better throughput.
* **Faster Response Times** - By optimizing GPU usage and reducing memory overhead, the inference server can process requests much faster. This is crucial for real-time applications where low latency is a priority.
* **Open Source and Flexible** - The open-source nature of vLLM means it can support a wide range of generative AI models and can be deployed on various AI accelerators across different cloud environments. This prevents vendor lock-in and provides greater flexibility.
* **Enterprise-Ready** - Red Hat provides the stability, security, and support that enterprises need to deploy AI models in production environments.
* **Red Hat Validated Models** - Red Hat AI provides access to a repository of third-party models that are validated to run efficiently across the platform. This set of leading third-party models are run through capacity guidance planning scenarios, so you can make informed decisions about the right combination of model, deployment settings, and hardware accelerator for your domain specific use cases.

## Hands-on Lab
In this module, we will walk you through the key features of Red Hat AI Inference Server.

![rhaiis-overview.png](images/rhaiis-overview.png)

**Agenda:**

* 📍 [Getting started - configure the lab workbench](1-getting-started.md)
* 📍 [Validate the lab environment](2-shakeout-test.md)
* 📍 [Inference with vLLM](3-inference-with-vllm.md)
* 📍 [Optimize the models](4-optimize-models.md)
* 📍 [Red Hat Validated Models](5-validated-models.md)