# Lab 1: Serving a Model with vLLM

This walkthrough guide will teach you how to serve an open-source model using vLLM (the upstream project of Red Hat AI Inference Server) and test its performance through benchmarking.

## Prerequisites

Before starting this walkthrough, ensure you have:
- A running JupyterLab environment with GPU access
- Access to the notebook `1-inference-with-vllm.ipynb` 
- Internet connectivity for downloading packages and models

## What You'll Learn

By completing this walkthrough, you'll understand:
- What an inference server is and how it works
- How to install and configure vLLM
- How to serve a model using vLLM
- How to test model inference via HTTP API
- Key performance metrics for LLM serving
- How to benchmark model performance

## Understanding Inference Servers

### What is an Inference Server?
An inference server is the piece of software that allows artificial intelligence (AI) applications to communicate with large language models (LLMs) and generate a response based on data. This process is called inference. It's where the business value happens and the end result is delivered.

### How does Red Hat AI Inference Server work?
Red Hat AI Inference Server provides fast and cost-effective inference at scale. Its open source nature allows it to support any generative AI (gen AI) model, on any AI accelerator, in any cloud environment.

Powered by [vLLM](https://docs.vllm.ai/en/latest/), the inference server maximizes GPU utilization, and enables faster response times. Combined with LLM Compressor capabilities, inference efficiency increases without sacrificing performance.

## Red Hat AI Repository

The Red Hat AI repository on Hugging Face is an open-source initiative backed by deep collaboration between IBM and Red Hat's research, engineering, and business units. We're committed to making AI more accessible, efficient, and community-driven from research to production.

**🔗 Red Hat AI Repository**: https://huggingface.co/RedHatAI

## Step-by-Step Walkthrough

### Step 1: Install vLLM

First, let's install the vLLM library using pip. Run the following cell in your notebook:

```python
%pip install vllm
```

**What this does**: Installs vLLM and all its dependencies including transformers, torch, and other required packages.

### Step 2: Understand vLLM Serve Command

vLLM provides a command-line interface for serving models. You can explore available options by running:

```bash
vllm serve -h
```

**Key parameters you'll use**:
- `--port`: Specify the port for the HTTP server (default: 8000)
- `--tensor-parallel-size`: Number of GPUs to use for tensor parallelism
- Model name: The Hugging Face model identifier

### Step 3: Choose Your Model

For this walkthrough, we'll use the `Llama-3.2-1B-Instruct-FP8` model from the Red Hat AI Repository. This model is optimized for inference with FP8 quantization.

**🔗 Model Details**: https://huggingface.co/RedHatAI/Llama-3.2-1B-Instruct-FP8

### Step 4: Start the Model Server

Open a **new terminal** in JupyterLab and run the following command:

```bash
vllm serve RedHatAI/Llama-3.2-1B-Instruct-FP8 --port 8000 --tensor-parallel-size 1
```

**Important**: 
- Keep this terminal open and running
- Wait for the message "Application startup complete" before proceeding
- The server will download the model on first use (this may take a few minutes)

**Parameters explained**:
- `RedHatAI/Llama-3.2-1B-Instruct-FP8`: The model to serve
- `--port 8000`: HTTP server will run on port 8000
- `--tensor-parallel-size 1`: Use 1 GPU for inference

### Step 5: Test the Inference Endpoint

Once the server is running, you can test it using curl or the notebook cell. vLLM provides an HTTP server that implements **OpenAI's Completions API, Chat API, and more!**

Run this cell in your notebook to test the endpoint:

```python
!curl -X POST -H "Content-Type: application/json" -d '{ \
    "prompt": "What is the capital of France?", \
    "max_tokens": 50 \
}' http://localhost:8000/v1/completions
```

**Expected response format**:
```json
{
  "id": "cmpl-...",
  "object": "text_completion",
  "created": 1751436165,
  "model": "RedHatAI/Llama-3.2-1B-Instruct-FP8",
  "choices": [
    {
      "index": 0,
      "text": " Paris\nWhat is the capital of France?\nThe capital of France is Paris.",
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 8,
    "total_tokens": 25,
    "completion_tokens": 17
  }
}
```

**✅ Success indicator**: If you receive a JSON response with the model's answer, your inference server is working correctly!

## Understanding Key Performance Metrics

When evaluating LLM inference performance, focus on these key metrics:

### Core Metrics
- **Time to first token (TTFT)**: How long does it take for the model to provide the first token of its response?
- **Time per output token (TPOT)**: How long does it take for the model to provide an output token to each user?
- **Latency**: How long does it take for the model to generate a complete response?
- **Throughput**: How many output tokens can a model produce simultaneously across all users and requests?

### Why These Metrics Matter
- **TTFT** affects user experience - lower is better for interactive applications
- **TPOT** determines streaming response quality
- **Latency** impacts overall response time
- **Throughput** determines how many users you can serve concurrently

## Step 6: Prepare for Benchmarking

To perform comprehensive benchmarking, you'll need additional packages. Install them with:

```python
%pip install pandas dataset
```

### Step 7: Clone vLLM Repository

The vLLM repository contains useful benchmarking tools. Clone it with:

```python
!git clone https://github.com/vllm-project/vllm.git
```

**Note**: If you see "fatal: destination path 'vllm' already exists", that's fine - the repository is already cloned.

### Step 8: Run Performance Benchmark

Execute the benchmark test against your running vLLM server:

```python
!python vllm/benchmarks/benchmark_serving.py \
--backend vllm --model RedHatAI/Llama-3.2-1B-Instruct-FP8 \
--num-prompts 100 --dataset-name random  --random-input 200 --random-output 200 --port 8000
```

**Parameters explained**:
- `--backend vllm`: Use vLLM as the backend
- `--model`: Model identifier (should match your serving model)
- `--num-prompts 100`: Send 100 test prompts
- `--dataset-name random`: Use randomly generated prompts
- `--random-input 200`: Random input length of ~200 tokens
- `--random-output 200`: Expected output length of ~200 tokens
- `--port 8000`: Connect to your running server

### Step 9: Analyze Benchmark Results

Your benchmark results will show metrics like:

```
============ Serving Benchmark Result ============
Successful requests:                     100       
Benchmark duration (s):                  4.65      
Total input tokens:                      19900     
Total generated tokens:                  17487     
Request throughput (req/s):              21.48     
Output token throughput (tok/s):         3756.84   
Total Token throughput (tok/s):          8032.07   
---------------Time to First Token----------------
Mean TTFT (ms):                          286.78    
Median TTFT (ms):                        297.96    
P99 TTFT (ms):                           392.87    
-----Time per Output Token (excl. 1st token)------
Mean TPOT (ms):                          22.30     
Median TPOT (ms):                        21.39     
P99 TPOT (ms):                           37.72     
---------------Inter-token Latency----------------
Mean ITL (ms):                           21.49     
Median ITL (ms):                         15.85     
P99 ITL (ms):                            50.49     
================================================== 
```

**Key insights from these results**:
- **Request throughput**: 19.43 requests per second
- **Output token throughput**: 3,359 tokens per second
- **Mean TTFT**: 530.89 milliseconds
- **Median TTFT**: 491.70 milliseconds

## Troubleshooting

### Common Issues

1. **Model download fails**: 
   - You may need a Hugging Face token for some models
   - Set your token: `!export HF_TOKEN=hf_xxxx`

2. **Server won't start**:
   - Check if port 8000 is already in use
   - Verify GPU availability
   - Ensure sufficient memory

3. **Benchmark fails**:
   - Ensure the server is running before starting benchmark
   - Check that the model name matches exactly

### Performance Comparison

Compare your results with published benchmarks like NVIDIA NIM serving performance:
**🔗 NVIDIA NIM Benchmarks**: https://docs.nvidia.com/nim/benchmarking/llm/latest/performance.html#llama-3-1-8b-instruct-results

## Next Steps

After completing this walkthrough, you can:

1. **Experiment with different models** from the Red Hat AI Repository
2. **Adjust serving parameters** for optimal performance
3. **Implement client applications** using the OpenAI-compatible API
4. **Scale to multiple GPUs** using tensor parallelism
5. **Deploy in production** with proper monitoring and load balancing

## Summary

You've successfully:

✅ Installed and configured vLLM  
✅ Served a model using Red Hat AI Inference Server  
✅ Tested inference via HTTP API  
✅ Benchmarked performance with real metrics  
✅ Understood key performance indicators  

You now have hands-on experience with enterprise-grade LLM inference serving!
