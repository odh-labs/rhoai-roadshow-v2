

## 💡 Disable the default vLLM inference serving
Our `Lab 1 - inference with vllm` is quite computational intensive, so to ensure the success of following jupyterlab notebook, we recommend to disable the default vLLM inference serving in the namespace `llama-serving`.

To do that, first login into the OpenShift CLI using `--token` or username/password given by the instructor.

```bash
oc login -u admin -p ${ADMIN_PASSWORD} --server=https://api.sno.${BASE_DOMAIN}:6443
```

Once you login the `oc` CLI, run the following respectively to enable/disable the defautl model serving.

```bash
# undeploy deepseek-qwen3
oc create configmap undeploy-sno-deepseek-qwen3-vllm -n llama-serving
# redeploy deepseek-qwen3
oc delete configmap undeploy-sno-deepseek-qwen3-vllm -n llama-serving

# undeploy llama3-2-3b
oc create configmap undeploy-llama3-2-3b -n llama-serving
# redeploy llama3-2-3b
oc delete configmap undeploy-llama3-2-3b -n llama-serving
```

Wait until the Pods are terminated before you continue with Lab 1.