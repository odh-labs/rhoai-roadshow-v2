# GPU as a Service

## Why do we care ?

GPU's enable GenAI workloads. IDC predicts Inferencing is expected to be 80% of GPU usage (compare to say training) in coming years.

One of the ROI benefits for GPU as a Service is you get to change the economic dynamics. Instead of paying for Input + Output $cost per/Token (GenAI SaaS services), you can use capex + opex to fund your own GPU's (on premise or in the cloud).

There are some constraints when doing GPU aaS:

- GPU's are scarce and have cost constraints
- Fragmented GPU infrastructure because of vendor/provider lock-in
- GPU utilization is a black box for SaaS
- Secure multi-tenancy for GPU's

Red Hat AI can help solve these constraints.

## What is it ?

GPU as a Service is a platform solution and architecture pattern. It allows:

- Tenant based resource allocation strategies for GPU's
- On-demand GPU access including GPU parallelism/concurrency
- Quotas, Limits, Cost and metrics tracking and observability
- Secure GPU multi-tenancy with different/tiered access levels
- The goal is any accelerator in any cloud

## How do we do it ?

- Based on world class secure operating systems (RHCOS) and deployment orchestration (OpenShift)
- GPU Parallelism can be configured using Operator configuration.
- Multi-instance multi-GPU configurations for large LLMs

## Roadshow workshop narrative

Hands-on lab

- Configure and deploy multiple GPU instances on RHOCP
- Configure accelerator profiles in RHOCP + RHOAI to demonstrate GPU concurrency usage
- Learn about quotas + observability + metrics available
