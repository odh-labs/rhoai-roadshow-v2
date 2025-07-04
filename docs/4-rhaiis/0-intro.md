# Introduction

## Create a project

Login to OpenShift AI and click "create project". Give it a name "vllm-demo" and add "This project is to demo the Red Hat AI Inference Server (RHAIIS)" as description (Optional).

Click "Create".

![images/create-project.png](images/create-project.png)

## Create a workbench

Select the `vllm-demo` data science project we just created, click `Create a workbench`.

![images/create-workbench.png](images/create-workbench.png)

We are going to `Create a workbench` using the following parameters:

    Name: vllm
    Image Selection: CUDA
    Version: 2025.1 (select the latest version)
   
Leave all the other fields as defaults. You should see the `Hardware profile` auto-selected to use the GPU Accelerator `Nvidida L4 (Shared)`.

Click `Create workbench`.

Wait until the status of workbench is changed to `Running`.

![images/workbench-ready.png](images/workbench-ready.png)

Click the name of the workbench `vllm`, and it will bring you to JupyterLab web console as below.
![images/jupyterlab-ready.png](images/jupyterlab-ready.png)


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