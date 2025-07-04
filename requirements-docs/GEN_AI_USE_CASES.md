# The Gen AI Use Case Approach

These are like Architecture Building Blocks (ABBs). Assemble them into a broader solution.

![images/gen-ai-technical-use-cases.png](images/genai-technical-use-cases.png)

We have technical use cases we wish to focus on for the RoadShow. Ideally these align to:

- What Attendees want to learn about Red Hat AI, things they will remember after the Roadshow and evangelize to their colleagues.
- What makes Red Hat AI Different - aka our differentiators
- What we have on the back of the truck i.e. features that we have or are upcoming that help you solve your real world GenAI problems

Generally they are pitched at two different personas:

1. The AI Application Developer & Engineer - who is responsible for bringing AI to existing applications or making new AI applications - closely aligned to the business.
2. The AI SRE or Platform Engineer - who is responsible for providing the platform and infrastructure to run AI applications.

In the Road Show we want attendees to be able to choose their own adventure with the workshop(s) they have hands-on experience with. Ideally we can incorporate feedback to the group about their experiences during the session.

We want to build out workshop narratives for each of the technical use cases we believe are most relevant (in GREEN in the picture).

`WIP` - The technical use cases form part of a Technical Architecture that meet business need(s) (the business use cases). Ideally we can present one-page solution architecture diagrams to accompany these.

# Module Leader

## TODO
- [ ] Define the epected outcome and success criteria for the roadshow. Aka what's good look like?

RAG - Bryon  
GPUaaS - Mike  
Platform - Mike  

Agents and Tools - Mike
AI Agents helps build autonomous systems to reason, plan and complete tasks. 
See how OpenShift AI can help build agentic systems enabling seamless integration of technologies like LLMs and GenAI into real-world applications. LLMs needs APIs to orchestrate with external tools, use external store for long and short term memory and help build human in the loop workflow. You will build an end to end agentic application using react approach with tool calling/MCP to support these capabilities.

Example Use Case: Build an Intelligent document processing system that 
react agent to provide autonomous capabilities and provide the following flow with LLM and tool calling. Notice that this complex workflow will not be hardcoded and LLM will shpw the flow based on different prompts and inputs:
1/ extracts info from a given document image using LLM/docling
2/ validates data using external APIs
3/ apply validation rules to the data
4/ decide to send for human approval or not

Guardrails - Mike
Guardrails enable your AI application for responsible AI usage, ensuring compliance with regulations and ethical standards. Learn how to implement guardrails in your AI applications using OpenShift AI. You will see how to apply guard rails in pre-call and post-call stages of LLMs. Combine it with AI Inference gateways to centrally manage and enforce guard rails across your AI applications.

Example Use Case: For the above use case: Apply guardrails to detect if the notes/comments/free form text field in the document contains sensitive info like PII. 

Observability - Mike
LLMs/Agents are complex systems that require observability to ensure reliability and performance. Evaluating LLM performance is another key factor to assess the suitability of LLMs and adapting new LLMs. See how OpenSource provides comprehensive observability features, including tracing, evaluation, prompt management, and metrics collection, enabling  to debug and improve their LLM applications effectively. 

Example Use Case: For the above use case: Capture end to end interaction of the flow with input/out of each step (such as system prompt, tool calling list, output and flow direction), flow steps, LLMs metrics and evaluation results based on custom functions.

Data Eng - Bryon
vLLM & Inference Server - Michael
