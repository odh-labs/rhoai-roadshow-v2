# Lab 3: Red Hat Validated Models and Model Catalog

This walkthrough guide will teach you about Red Hat's validated models, the model catalog feature, and how to deploy models using modern approaches like KServe Modelcar.

## Prerequisites

Before starting this walkthrough, ensure you have:
- A running JupyterLab environment with GPU access
- Access to the notebook `3-validated-models.ipynb`
- Red Hat OpenShift AI environment
- Internet connectivity for downloading packages and models

## What You'll Learn

By completing this walkthrough, you'll understand:
- What are Red Hat validated models and their benefits
- How to access and use the Red Hat AI repository on HuggingFace
- What is the Model Catalog feature and how to use it
- How to deploy validated models on Red Hat OpenShift AI
- Modern deployment approaches using KServe Modelcar
- Features and benefits of optimized models

## Understanding Red Hat Validated Models

### What are Validated Models?

Red Hat validated models are pre-tested, optimized, and verified models that have been extensively evaluated for performance, accuracy, and reliability. These models undergo rigorous testing and validation processes to ensure they meet enterprise standards.

### Red Hat AI Repository on HuggingFace

The Red Hat AI repository on Hugging Face is an open-source initiative backed by deep collaboration between IBM and Red Hat's research, engineering, and business units. We're committed to making AI more accessible, efficient, and community-driven from research to production.

**🔗 Red Hat AI Repository**: https://huggingface.co/RedHatAI

### Features and Benefits

Red Hat validated models offer several key advantages:

- **Performance Optimization**: Models are optimized for inference speed and efficiency
- **Quality Assurance**: Extensive testing ensures reliability and accuracy
- **Enterprise Support**: Professional support and maintenance
- **Security**: Models undergo security validation and compliance checks
- **Compatibility**: Tested for compatibility with Red Hat OpenShift AI platform
- **Documentation**: Comprehensive documentation and usage examples

### Validated Models

Red Hat provides a curated selection of validated models including:

- **Language Models**: Large language models optimized for various use cases
- **Code Generation**: Models specialized for code generation and completion
- **Chat Models**: Conversational AI models for interactive applications
- **Instruct Models**: Models fine-tuned for instruction following
- **Quantized Models**: Memory-efficient versions with various precision levels

### Optimized Models

Red Hat AI also provides optimized versions of popular models:

- **Quantized Variants**: FP8, INT8, and INT4 quantizations for memory efficiency
- **Compressed Models**: Using techniques like pruning and knowledge distillation
- **Hardware-Specific**: Models optimized for specific hardware accelerators
- **Multi-GPU Support**: Models configured for distributed inference

## Deploy a Validated Model on Red Hat OpenShift AI

### Step 1: Access the Model Catalog

Red Hat OpenShift AI provides a Model Catalog feature that makes it easy to discover, deploy, and manage validated models.

**📚 Model Catalog Features:**
- Curated collection of validated models
- One-click deployment options
- Version management and updates
- Integration with model registry
- Performance metrics and monitoring

### Step 2: Browse Available Models

The Model Catalog contains two main categories:

1. **Red Hat Models**: Validated and supported models from Red Hat AI
2. **Third-party Models**: Community and partner models that have been validated

### Step 3: Select and Deploy a Model

To deploy a model from the catalog:

1. Navigate to the Model Catalog in your OpenShift AI dashboard
2. Browse or search for the desired model
3. Click on the model to view details and specifications
4. Review the model card, performance metrics, and requirements
5. Click "Deploy" to start the deployment process
6. Configure deployment parameters (resources, scaling, etc.)
7. Monitor the deployment status and health

### Step 4: Model Configuration

When deploying a model, you can configure:

- **Resource Requirements**: CPU, memory, and GPU specifications
- **Scaling Options**: Auto-scaling parameters and limits
- **Network Configuration**: Endpoints and access controls
- **Storage**: Persistent storage for model artifacts
- **Environment Variables**: Custom configuration options

## 🏆 A Modern Way - KServe Modelcar Approach

### What is KServe Modelcar?

KServe Modelcar is a modern, cloud-native approach to model serving that provides:

- **Serverless Scaling**: Automatic scaling based on demand
- **Multi-Framework Support**: Support for various ML frameworks
- **Advanced Routing**: Traffic splitting and canary deployments
- **Monitoring Integration**: Built-in observability and metrics
- **Version Management**: Easy model versioning and rollbacks

### Benefits of KServe Modelcar

1. **Simplified Deployment**: Declarative model serving with minimal configuration
2. **Cost Efficiency**: Pay-per-use scaling reduces infrastructure costs
3. **High Availability**: Built-in fault tolerance and load balancing
4. **Developer Experience**: Git-ops style model management
5. **Production Ready**: Enterprise-grade features out of the box

### Deploying with KServe Modelcar

The KServe Modelcar approach uses a simple YAML configuration to define model serving:

```yaml
---
apiVersion: serving.kserve.io/v1alpha1
kind: ServingRuntime
metadata:
  annotations:
    enable-route: 'true'
    opendatahub.io/accelerator-name: nvidia-gpu
    opendatahub.io/apiProtocol: REST
    opendatahub.io/recommended-accelerators: '["nvidia.com/gpu"]'
    opendatahub.io/template-display-name: vLLM ServingRuntime for KServe
    opendatahub.io/template-name: vllm-runtime
    openshift.io/display-name: sno-granite-8b-lab-v2-vllm
    argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
    argocd.argoproj.io/sync-wave: "4"
  labels:
    opendatahub.io/dashboard: "true"
  name: sno-granite-8b-lab-v2-vllm
  namespace: llama-serving
spec:
  annotations:
    prometheus.io/path: /metrics
    prometheus.io/port: "8080"
  containers:
    - command:
        - python
        - -m
        - vllm.entrypoints.openai.api_server
        - --port=8080
        - --model=/mnt/models
        - --served-model-name=granite-8b-lab-v2-preview
        - --max-model-len=35000
        - --enforce-eager
        - --gpu_memory_utilization=0.99
        - --enable-auto-tool-choice
        - --tool-call-parser=granite
        - --chat-template=/app/data/template/tool_chat_template_granite.jinja
      env:
        - name: HF_HOME
          value: /tmp/hf_home
      image: quay.io/eformat/vllm:latest  # quay.io/modh/vllm:rhoai-2.21-cuda
      name: kserve-container
      ports:
        - containerPort: 8080
          protocol: TCP
  multiModel: false
  supportedModelFormats:
    - autoSelect: true
      name: vLLM
---
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  annotations:
    openshift.io/display-name: sno-granite-8b-lab-v2-vllm
    serving.knative.openshift.io/enablePassthrough: "true"
    sidecar.istio.io/inject: "true"
    sidecar.istio.io/rewriteAppHTTPProbers: "true"
    serving.kserve.io/deploymentMode: Serverless
    argocd.argoproj.io/sync-options: SkipDryRunOnMissingResource=true
    argocd.argoproj.io/sync-wave: "4"
  labels:
    opendatahub.io/dashboard: "true"
  name: sno-granite-8b-lab-v2-vllm
  namespace: llama-serving
spec:
  predictor:
    maxReplicas: 1
    minReplicas: 1
    model:
      modelFormat:
        name: vLLM
      name: ''
      resources:
        limits:
          nvidia.com/gpu: "1"
        requests:
          nvidia.com/gpu: "1"
      runtime: sno-granite-8b-lab-v2-vllm
      storageUri: oci://registry.redhat.io/rhelai1/modelcar-granite-8b-lab-v2-preview:1.4.0
    tolerations:
    - effect: NoSchedule
      key: nvidia.com/gpu
      operator: Exists
---
kind: Secret
apiVersion: v1
metadata:
  name: modelcar-granite-8b-lab-v2-preview
  namespace: llama-serving
  labels:
    opendatahub.io/dashboard: 'true'
  annotations:
    opendatahub.io/connection-type-ref: uri-v1
    openshift.io/description: modelcar-granite-8b-lab-v2-preview
    openshift.io/display-name: modelcar-granite-8b-lab-v2-preview
    argocd.argoproj.io/sync-wave: "2"
stringData:
  URI: oci://registry.redhat.io/rhelai1/modelcar-granite-8b-lab-v2-preview:1.4.0
type: Opaque
```

### Model Catalog Integration

The Model Catalog integrates seamlessly with KServe Modelcar by:

1. **Automated Configuration**: Generating KServe configurations from model metadata
2. **Resource Optimization**: Recommending optimal resource allocations
3. **Dependency Management**: Handling model dependencies and requirements
4. **Monitoring Setup**: Configuring observability and alerting
5. **Security Policies**: Applying security and compliance policies

## 💡 Model Catalog Deep Dive

### Key Features

The Model Catalog provides several advanced features:

1. **Model Discovery**: Search and filter models by various criteria
2. **Metadata Management**: Rich metadata including performance metrics
3. **Version Control**: Track model versions and lineage
4. **Deployment Templates**: Pre-configured deployment templates
5. **Resource Estimation**: Automatic resource requirement calculation
6. **Compatibility Checks**: Validate model compatibility with your environment

### Using the Model Catalog

To effectively use the Model Catalog:

1. **Browse Collections**: Explore curated model collections
2. **Read Model Cards**: Review detailed model documentation
3. **Check Performance**: Analyze benchmark results and metrics
4. **Verify Compatibility**: Ensure model fits your requirements
5. **Deploy Easily**: Use one-click deployment options
6. **Monitor Performance**: Track model performance post-deployment

### Best Practices

When working with the Model Catalog:

- **Start Small**: Begin with smaller models to test your pipeline
- **Review Documentation**: Always read model cards and documentation
- **Test Thoroughly**: Validate model performance in your environment
- **Monitor Resources**: Track resource usage and costs
- **Keep Updated**: Regularly update to newer model versions
- **Plan for Scale**: Design for production-level traffic

## Advanced Features

### Model Registry Integration

The Model Catalog integrates with the Model Registry to provide:

- **Version Management**: Track model versions and metadata
- **Lineage Tracking**: Understand model development history
- **Approval Workflows**: Implement governance and approval processes
- **Audit Trails**: Maintain compliance and audit records
- **Collaboration**: Enable team collaboration on model development

### Monitoring and Observability

Red Hat OpenShift AI provides comprehensive monitoring for deployed models:

- **Performance Metrics**: Latency, throughput, and resource utilization
- **Model Metrics**: Accuracy, drift detection, and data quality
- **Business Metrics**: Custom metrics for business KPIs
- **Alerting**: Automated alerts for anomalies and issues
- **Dashboards**: Pre-built and custom dashboards for visualization

### Security and Compliance

Validated models come with built-in security features:

- **Vulnerability Scanning**: Regular security scans and updates
- **Access Controls**: Role-based access and permissions
- **Encryption**: Data encryption in transit and at rest
- **Compliance**: Meet industry standards and regulations
- **Audit Logging**: Comprehensive audit trails

## Summary

Red Hat validated models and the Model Catalog provide a powerful platform for deploying production-ready AI models. Key benefits include:

- **Simplified Deployment**: Easy-to-use catalog and deployment tools
- **Enterprise Ready**: Validated, supported, and secure models
- **Modern Architecture**: Cloud-native serving with KServe
- **Cost Effective**: Efficient resource utilization and scaling
- **Comprehensive Monitoring**: Full observability and management

The combination of validated models, modern serving infrastructure, and comprehensive tooling makes Red Hat OpenShift AI an ideal platform for enterprise AI deployment.

## Next Steps

After completing this walkthrough, consider:

1. **Explore More Models**: Try different models from the catalog
2. **Optimize Performance**: Experiment with quantized and optimized models
3. **Implement Monitoring**: Set up comprehensive monitoring and alerting
4. **Scale to Production**: Plan for production-level deployments
5. **Integrate with Applications**: Connect models to your applications
6. **Learn Advanced Features**: Explore advanced serving and management features

---

This completes Lab 3 - Red Hat Validated Models and Model Catalog. You now have the knowledge and tools to effectively deploy and manage validated models in your Red Hat OpenShift AI environment. 