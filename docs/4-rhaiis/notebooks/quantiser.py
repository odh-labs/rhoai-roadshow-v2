from __future__ import annotations

from typing import List

from transformers import AutoModelForCausalLM
from llmcompressor.transformers.compression.helpers import calculate_offload_device_map
from llmcompressor import oneshot
from llmcompressor.modifiers.quantization import QuantizationModifier


def quantise_model(
    model_stub: str = "TinyLlama/TinyLlama-1.1B-Chat-v1.0",
    *,
    scheme: str = "W4A16",
    targets: str = "linear",
    ignore: List[str] | None = None,
    num_gpus: int = 1,
    reserve_for_hessians: bool = False,
    save: bool = True,
) -> str:
    """
    Quantises a causal language model using the llmcompressor one‑shot API.

    Parameters
    ----------
    model_stub:
        Hugging Face model identifier or local path.
    scheme:
        Quantisation scheme to apply (e.g. ``"W4A16"``, ``"NVFP4"``, ``"FP8_dynamic"``).
    targets:
        Module filter selecting which layers to quantise.
    ignore:
        List of module names to leave untouched.
    num_gpus:
        Number of GPUs to include when calculating the device map.
    reserve_for_hessians:
        Whether to reserve GPU memory for Hessian computations (rarely needed for one‑shot).
    save:
        If *True*, the quantised model weights are persisted to disk.

    Returns
    -------
    str
        Directory path where the quantised model has been written.
    """
    if ignore is None:
        ignore = ["lm_head"]

    # Determine where to place the model weights
    device_map = calculate_offload_device_map(
        model_stub,
        reserve_for_hessians=reserve_for_hessians,
        num_gpus=num_gpus,
        torch_dtype="auto",
    )

    # Load the base model
    model = AutoModelForCausalLM.from_pretrained(
        model_stub, device_map=device_map, torch_dtype="auto"
    )

    # Construct the quantisation recipe
    recipe = QuantizationModifier(
        targets=targets,
        scheme=scheme,
        ignore=ignore,
    )

    # Apply quantisation in one shot
    oneshot(model=model, recipe=recipe)

    # Optionally persist to disk
    save_path = f"{model_stub}-{scheme}"
    if save:
        model.save_pretrained(
            save_path,
            skip_compression_stats=True,
            disable_sparse_compression=True,
        )
        print(f"Quantised model saved to: {save_path}")

    return save_path


if __name__ == "__main__":  # pragma: no cover
    quantise_model()