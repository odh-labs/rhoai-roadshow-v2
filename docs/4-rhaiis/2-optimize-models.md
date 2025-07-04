# Lab 2: Optimize Models - Step-by-Step Guide

## Overview

This guide walks through how to optimize open source models using vLLM's `llm-compressor` tool. You'll learn about quantization techniques, model memory requirements, and how to validate accuracy after optimization.

## What is llm-compressor?

`llm-compressor` is an easy-to-use library for optimizing models for deployment with `vllm`, including:

- **Comprehensive quantization algorithms** for weight-only and activation quantization
- **Seamless integration** with HuggingFace models and repositories
- **safetensors-based file format** compatible with `vllm`
- **Large model support** via `accelerate`

LLM Compressor supports both post-training and training workflows for compression through Modifiers, implementations that apply specific compression methods to models. Modifier implementations cover:

- **Weight-only quantization (W4A16)** for limited hardware or latency-sensitive applications
- **Weight and activation quantization (W8A8)** targeting general server scenarios
- **2:4 semi-structured sparsity** for further inference acceleration

## Why Optimize Models?

### The Memory Gap Challenge

There's a growing disparity between model sizes and available GPU memory:
- Some of today's largest MoE architectures exceed **1.8 trillion parameters**
- Even advanced GPUs like Blackwell are limited to **192GB** of memory

### Quantization Benefits

Quantization significantly reduces memory requirements. Here are practical examples:

#### Llama4 Scout: 109B Parameters
| Optimization | Params Size (GiB) | GPUs Required |
|--------------|-------------------|---------------|
| BFloat16     | 109 × 2 ≈ 220 GB | 3 × H100 (80GB) |
| INT8/FP8     | 109 × 1 ≈ 109 GB | 2 × H100 (80GB) |
| INT4         | 109 × 0.5 ≈ 55 GB | 1 × H100 (80GB) |

#### Llama4 Maverick: 400B Parameters
| Optimization | Params Size (GiB) | GPUs Required |
|--------------|-------------------|---------------|
| BFloat16     | 400 × 2 ≈ 800 GB | 10 × H100 (80GB) |
| INT8/FP8     | 400 × 1 ≈ 400 GB | 5 × H100 (80GB) |
| INT4         | 400 × 0.5 ≈ 200 GB | 3 × H100 (80GB) |

### Key Advantages
- **Reduced memory usage** - frees up GPU RAM for critical components like KV Cache
- **Accelerated inference** - leverages low-precision tensor cores in modern GPUs
- **Minimal accuracy degradation** - maintains model performance while reducing resource requirements

## Real Example: Model Sizing Estimation

Let's walk through estimating memory requirements for the **IBM Granite 3.2 8B Instruct** model.

### Model Specifications
- **Model size**: 8.17B parameters
- **Tensor type**: BF16 (2 bytes per parameter)
- **Hidden layers**: 40
- **Key-Value heads**: 8
- **Attention heads**: 32
- **Hidden size**: 4096 (dimensions per layer)
- **Head size**: 128 (Hidden Size / Attention heads)
- **Max context length**: 131,072 (128K tokens)

### Memory Calculations

#### Model vRAM Estimate
```
Model vRAM = Number of Parameters × Model Precision × 20% overhead
Model vRAM = 8.17B × 2 bytes × 1.2 = 18.3 GiB
```

#### KV Cache Estimate
```
vRAM per token = 2 (key & value) × hidden layers × key-value heads × head size × 2 bytes
vRAM per token = 2 × 40 × 8 × 128 × 2 = 0.16 MiB

For 1 concurrent request:
Total KV Cache = 0.16 MiB × 128K tokens × 1 = 20.5 GiB
```

#### Total Memory Requirement
```
Total vRAM = Model vRAM + KV Cache = 18.3 + 20.5 = 38.8 GiB
```

## Hands-on: Quantizing a Model

### Step 1: Install Dependencies

First, install the required packages:

```bash
pip install llmcompressor==0.5.1
```

Verify the installation:
```bash
pip list | grep llmcompressor
```

### Step 2: Create the Quantization Script

Create a file named `quantize.py` with the following content:

```python
from transformers import AutoTokenizer, AutoModelForCausalLM
from llmcompressor.transformers.compression.helpers import calculate_offload_device_map
from llmcompressor import oneshot
from llmcompressor.modifiers.quantization import QuantizationModifier

# Load the target model
model_stub = "TinyLlama/TinyLlama-1.1B-Chat-v1.0"
device_map = calculate_offload_device_map(
    model_stub,
    reserve_for_hessians=False,
    num_gpus=1,
    torch_dtype="auto"
)

model = AutoModelForCausalLM.from_pretrained(
    model_stub,
    device_map=device_map,
    torch_dtype="auto"
)

# Specify the quantization recipe
recipe = QuantizationModifier(
    targets="linear",
    scheme="W4A16",  # Options: NVFP4, W4A16, FP8_dynamic
    ignore=["lm_head"]
)

# Apply quantization
oneshot(model=model, recipe=recipe)

# Save the quantized model
save_path = model_stub + "-W4A16"
model.save_pretrained(save_path, skip_compression_stats=True, disable_sparse_compression=True)
print(f"Quantized model saved to: {save_path}")
```

### Step 3: Run the Quantization

Execute the script:

```bash
python3 quantize.py
```

You should see output indicating the compression lifecycle and successful model saving.

### Step 4: Verify the Quantized Model

Check the generated model files:

```bash
ls -lsah TinyLlama/TinyLlama-1.1B-Chat-v1.0-W4A16
```

**Note**: For larger models like Mistral-7B-v0.1, the compression is more significant:
- **Pre-quantized**: ~29.48 GiB
- **Post-quantized**: ~13.7 GiB
- **Savings**: 50%+ reduction in memory usage

## Quantization Schemes

LLM Compressor supports multiple quantization schemes:

- **W4A16**: Weight-only quantization for memory-bound, low-QPS scenarios
- **INT8** and **FP8**: Full quantization for compute-bound, high-throughput deployments
- **KV Cache Quantization**: For efficient long-context inference
- **Structured sparsity (2:4)**: For compact, efficient model representation

## Validating Accuracy After Quantization

### Step 5: Install Evaluation Tools

```bash
pip install vllm==0.9.0 lm-eval==0.4.7
```

### Step 6: Evaluate the Original Model

Test the unquantized model on the HellaSwag benchmark:

```bash
lm-eval --model vllm \
  --model_args pretrained=TinyLlama/TinyLlama-1.1B-Chat-v1.0,tensor_parallel_size=1 \
  --limit 250 --tasks hellaswag --num_fewshot 5 --batch_size 5
```

**Note**: This process can take 20-30 minutes to complete.

### Step 7: Evaluate the Quantized Model

Test the quantized model with the same benchmark:

```bash
lm-eval --model vllm \
  --model_args pretrained=TinyLlama/TinyLlama-1.1B-Chat-v1.0-W4A16,tokenizer=TinyLlama/TinyLlama-1.1B-Chat-v1.0,tensor_parallel_size=1 \
  --limit 250 --tasks hellaswag --num_fewshot 5 --batch_size 5
```

**Important**: When evaluating quantized models, you must specify the tokenizer explicitly.

### Step 8: Calculate Accuracy Recovery

Based on the evaluation results:

- **Pre-quantized accuracy**: 0.576
- **Post-quantized accuracy**: 0.564

**Accuracy Recovery Calculation**:
```
Accuracy Recovery = Post-quantized accuracy / Pre-quantized accuracy
Accuracy Recovery = 0.564 / 0.576 × 100% = 97.92%
```

## Results and Benefits

### Real-World Performance

Red Hat AI has run over 500,000 evaluations on quantized models, achieving approximately **99% accuracy retention** across various model architectures.

### Production Example

A popular gaming company used Red Hat's INT8 quantized Llama 70B with vLLM to power hundreds of thousands of daily code generations:

- **Performance**: 10 queries per second at 50ms per token
- **Cost savings**: 50% reduction in infrastructure costs
- **GPU efficiency**: 50% reduction in GPU usage
- **Quality**: No sacrifice in performance

## Summary

Model optimization with LLM Compressor and vLLM provides significant advantages:

✅ **Lower operational costs** - 40-50% GPU savings \
✅ **Faster deployment** - streamlined optimization process  \
✅ **Maintained accuracy** - minimal performance degradation \
✅ **Real-time responsiveness** - improved inference speed \
✅ **Scalability** - deploy AI smarter and cheaper \

Whether you're scaling a startup or steering an enterprise, quantization lets you deploy AI more efficiently while maintaining quality and performance.

## Next Steps

1. **Experiment with different quantization schemes** (INT8, FP8, W4A16)
2. **Test with larger models** to see more significant compression benefits
3. **Evaluate on your specific use case** benchmarks
4. **Consider structured sparsity** for additional optimizations
5. **Explore KV Cache quantization** for long-context applications

## Additional Resources

- [LLM Compressor Documentation](https://github.com/vllm-project/llm-compressor)
- [LLM Compressor: Optimize LLMs for low-latency deployments](https://developers.redhat.com/articles/2025/05/09/llm-compressor-optimize-llms-low-latency-deployments)
- [vLLM Documentation](https://docs.vllm.ai/) 