# Agents and Tools

## Why do we care ?

Agentic AI is the new hotness in GenAI - Why ? it encompasses integrating AI powered tools and agents with the generative abilities of LLM's to solve complex business use cases. Human's can interact with Agentic AI systems using natural language prompts. Some example use cases:

- SRE IT Operations uses cases e.g. interacting with your systems in real time to assess and take action on issues
- Knowledge retrieval from RAG, web-search, databases to take action based on insights
- Call centers to orchestrate intelligence and automation across the multiple activities involved in serving customers, analyzing sentiment, reviewing customer history

The list goes on and is really only limited by the imagination of the business and the constraints of being able to put it into action.

## What is it ?

Agents and tools are integrated together with LLM's using orchestration frameworks like LLamaStack. The Model Context Protocol (MCP) is the standard for integrating these pieces together. To build agentic systems requires a lot of moving pieces:

- LLM's to generate calls to tools as well as providing LLM abilities e.g. summarization, tool calling, genratvive capabilities
- AI Platform to serve LLM's and container based applications
- MCP servers to integrate to different tools and agents
- Orchestration servers e.g. LLamaStack deployment to process users sessions and hold the Agentic AI system configurations including built in tools such as web-search, RAG
- Ability to test and evaluate agentic systems
- MLOPS CI/CD capabilities to deploy and modify agentic systems
- Guardrail models for AI security on input and output tokens

## How do we do it ?

We can showcase application capability

- OpenShift + RHOAI
- LLamaStack deployment
- MCP Servers
- User interfaces (Chat or Notebook)

## Roadshow workshop narrative

Hands-on lab

- Configure and deploy LLamaStack
- Configure MCP servers e.g. (mcp::opershift, mcp::github, mcp::rag, mcp::websearch)
- Interact using UI with the agentic system for an example use case e.g. Agentic SRE/Ops

---

# Bryon's Suggestions
===

# Agentic AI with LamaStack on OpenShift AI

## Why do customers care?

### Situation  
Traditional GenAI systems generate answers in a single-shot, stateless format. However, many business tasks require multiple steps, tool use, reasoning, memory, and autonomy. Agentic AI is emerging as a new kind of dynamic business process automation and customers increasingly want **AI agents** that can plan, call APIs, interact with files, and execute workflows.  

### Complication  
Agentic AI introduces complexity: multiple components, tool registration, reasoning traces, and memory management. Tools must be secure, predictable, and observable—especially in enterprise environments. 
Customers are looking for:  
a. Examples that show *how* to build and *why* it matters.
b. Platform capabilities that hide the underlying complexity so they can justy focus on their application.

---

## Why does Red Hat care?

### Situation  
Agentic AI is the new hotness in GenAI - Why ? it encompasses integrating AI powered tools and agents with the generative abilities of LLM's to solve complex business use cases. Human's can interact with Agentic AI systems using natural language prompts. Some example use cases:

- SRE IT Operations uses cases e.g. interacting with your systems in real time to assess and take action on issues
- Knowledge retrieval from RAG, web-search, databases to take action based on insights
- Call centers to orchestrate intelligence and automation across the multiple activities involved in serving customers, analyzing sentiment, reviewing customer history

The list goes on and is really only limited by the imagination of the business and the constraints of being able to put it into action.

### Complication  
Red Hat has product capability gaps that are filled by the hyperscalers and other vendor offerings. This means customer's currently have to take on the burden of confiuring and maintaining the agentic platform.
Agentic systems require a higher level of orchestration. Tools must run securely in a multitenant containerised environment, and developers need simple APIs to register, invoke, and debug tools. Customers expect examples and modules that work within OpenShift AI with minimal friction.

---
## How do we do it ?

We can showcase application capability.
- OpenShift + RHOAI
- LLamaStack deployment
- MCP Servers
- User interfaces (Chat or Notebook)

---

## What is LamaStack?

**LamaStack** is an open-source framework for building agentic GenAI systems. It enables LLMs to:
- Use tools (APIs, files, vector search, shell)
- Maintain multi-turn memory
- Execute multi-step plans  
- Emit structured reasoning traces

With LamaStack, agents become capable **actors**—not just responders. Agents decide *what to do*, *which tool to use*, and *how to chain results* across steps.

---

## Constraints of a Training Environment

| Constraint | Impact |
|-----------|--------|
| Inability to control Internet-hosted tools | Agent tools must be simulated or containerised |
| Limited resources | No heavy compute (e.g. video rendering) |
| Security | No real shell or unrestricted execution |
| Predictability | Tools must return stable, testable responses |
| Speed | Tools must complete in < 5 seconds |

This ensures the lab runs reliably in workshops, clusters, and student environments.

---

## What Tools Might We Use?

In this module, we should include a curated set of **safe, deterministic, and meaningful tools**. Ideas are:

### 1. Math Tool  
A basic calculator that accepts expressions and returns results.  
**Use Case:**  
> "What is 5% of 900 + 3.7% of 2000?"  
Agent calls tool:  
`math_tool.calculate("0.05 * 900 + 0.037 * 2000") → 133.5`

---

### 2. Document Search Tool (RAG)  
Queries a vector database (e.g., Milvus) for semantically similar document chunks.  
**Use Case:**  
> "What’s the leave policy for part-time employees?"  
Agent calls:  
`doc_search.query("leave policy for part-time") → returns Fair Work Commission policy excerpt`

---

### 3. Shell Simulation Tool  
Simulates basic shell commands (`ls`, `mkdir`, `echo`, `cat`) in a sandboxed file structure.  
**Use Case:**  
> "Create a folder called reports and add a file today.txt with today’s date"  
Agent chains tool calls:  
- `mkdir reports`  
- `echo "2025-06-18" > reports/today.txt`

---

### 4. Knowledge Base Tool  
Queries static YAML/JSON files for HR policies or IT knowledge.  
**Use Case:**  
> "How many days of annual leave do I get?"  
Agent calls tool:  
`kb_tool.query("annual leave") → 20 days`

---

### 6. Data Inspector Tool  
Accepts CSV or DataFrame input, returns summaries and answers.  
**Use Case:**  
> "How many employees joined after 2023?"  
Agent calls:  
`data_tool.query(csv_path="hr-data.csv", question="joined after 2023")`

---

## Architecture Overview

Each tool runs as an HTTP service with a documented OpenAPI spec.  
The LamaStack agent:
- Uses the tools via REST
- Maintains memory of past actions
- Emits reasoning traces
- Runs in a container on OpenShift AI

## Instructional Objectives

Participants will learn to:

- Understand what agentic AI is and why it matters  
- Use LamaStack to register and invoke tools  
- Inspect agent traces and multi-step reasoning  
- Build and run agent workflows inside OpenShift AI  
- Understand how tools expose capabilities to the agent  

---

## Hands-on Lab Activities

1. **Shakeout**  
   Run a python notebook to validate the environment prior to commencing.

2. **Tool Registration**  
   Define tools in `tools.yaml` and register them with LamaStack.

3. **Basic Agent**  
   Using a Jupyter notebook, ask a simple prompt (`"What is 9 * 13 + 100?"`) and inspect the tool trace.

4. **Multi-Tool Task**  
   Using a Jupyter notebook, ask an agent to:
   - Search work entitlement (via RAG)
   - Write the answer to a file (shell tool)

5. **Trace Analysis**  
   View the step-by-step reasoning and API calls used.

---

## Roadshow Narrative

- Explain the limitations of stateless LLM prompts  
- Introduce LamaStack and how agents can use tools  
- Walk through each tool’s use and purpose  
- Prsactice how tools are registered and exposed  
- Practice multi-step agent execution  
