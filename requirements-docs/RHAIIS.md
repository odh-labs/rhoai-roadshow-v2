# Red Hat AI Inference Server & vLLM

The modern high performance LLM serving engine - Red Hat AI Inference Server & vLLM.

## Why do we care?
In the rapidly evolving world of Generative AI, deploying large language models (LLMs) efficiently is a significant challenge. As models become more powerful, they also become more resource-intensive, leading to high operational costs and slow response times. This is where vLLM and the Red Hat AI Inference Server come in.

The key benefits are:
* **Maximized GPU Utilization** - Traditional inference methods often underutilize expensive GPU resources. The server, powered by vLLM, employs a novel memory management technique called PagedAttention to minimize memory waste and fragmentation. This allows for higher batch sizes and, consequently, better throughput.
* **Faster Response Times** - By optimizing GPU usage and reducing memory overhead, the inference server can process requests much faster. This is crucial for real-time applications where low latency is a priority.
* **Open Source and Flexible** - The open-source nature of vLLM means it can support a wide range of generative AI models and can be deployed on various AI accelerators across different cloud environments. This prevents vendor lock-in and provides greater flexibility.
* **Enterprise-Ready** - Red Hat provides the stability, security, and support that enterprises need to deploy AI models in production environments.
* **Red Hat Validated Models** - Red Hat AI provides access to a repository of third-party models that are validated to run efficiently across the platform. This set of leading third-party models are run through capacity guidance planning scenarios, so you can make informed decisions about the right combination of model, deployment settings, and hardware accelerator for your domain specific use cases.

## What is it?
The Red Hat AI Inference Server is a powerful, enterprise-grade solution for serving large language models. It is built on the open-source vLLM library, a state-of-the-art engine for LLM inference and serving.

At its core, the server is designed to make the process of deploying and running LLMs as efficient as possible. It abstracts away the complexities of the underlying hardware and provides a simple, consistent API for developers to interact with. Red Hat's involvement ensures that the server is well-supported, secure, and can be integrated seamlessly into existing enterprise workflows and platforms like Red Hat OpenShift.

## How do we do it?
Red Hat has strategically embraced the open-source project vLLM to power its Red Hat AI Inference Server, aiming to provide an enterprise-grade, high-performance, and flexible solution for serving large language models (LLMs). 

Red Hat takes the core vLLM open-source project and enhances it with enterprise-focused features, packaging it into the Red Hat AI Inference Server. This includes:
* **Hardened and Supported Distribution** - Red Hat provides a commercially supported and security-hardened version of vLLM. This is crucial for enterprises that require reliability, stability, and timely security patches for their production environments.
* **Containerized Offering** - The Red Hat AI Inference Server is delivered as a container image. This facilitates easy deployment, scalability, and portability across various environments, including on-premises data centers and public clouds. It can be run as a standalone server or integrated into larger platforms.
* **Integration with Neural Magic** - Following its acquisition of Neural Magic, Red Hat is integrating its technology for model optimization. This allows for techniques like quantization and pruning to be applied to LLMs, reducing their size and computational requirements without a significant loss in accuracy.
* **Validated Models** - We have tested third-party models using realistic scenarios to understand exactly how they will perform in the real world. We use specialized tooling to assess LLM performance across a range of hardware.

## Roadshow Workshop Narrative
The promise of AI is immense, but the reality of putting it into production can be a painful experience.

But what if there was a better way? What if you could deploy your LLMs with the click of a button, on a platform that is optimized for performance and cost-efficiency? What if you could free up your developers to focus on what they do best: building amazing applications?

This is where the Red Hat AI Inference Server comes in. We've taken the cutting-edge technology of vLLM and combined it with the enterprise-grade stability and support of Red Hat to create a solution that makes it easy to deploy and manage LLMs at scale. In this workshop, we'll show you how you can use the Red Hat AI Inference Server to unlock the full potential of AI in your organization."

## Hands-on lab
- Developer experiment - Ramalama
- Standalone RHAIIS deployment on RHEL
- vLLM Serving Runtime on RHOAI

[BB] Suggestion: We can have two model varients from the Red Hat Validated Models registry. They can run a FP16 and an FP8 using the llmeval tool and see the benefits of compressed models.
