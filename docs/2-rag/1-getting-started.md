# 💁 Introduction

In this exercise we will configure the workbench that you will use for the lab. Follow the steps described in this document to configure the lab environment.

# Login to OpenShift AI

Your instructor will supply you with a link that you will use to login to your OpenShift AI cluster.

1. Open the OpenShift AI console using the url provided by your instructor.  
2. Use the following credentials to login to OpenShift AI:  
      **Username:** *admin*  
      **Password:** *r3dh4t*

# Create a workbench

3. Select the `rag-demo` data science project.

![./images/create-workbench.png](images/create-workbench.png)

4. Enter the following details into the **Create workbench** form:

   Name: **rag-workbench**  
   Image Selection: **CUDA**  
   Version: **2025.1 (Recommended)**  
   Hardware profile: **NVIDIA L4 (Shared)**  

![./images/create-workbench-1.png](images/create-workbench-1.png)

---

## Enter the S3 storage credentials

5. Scroll down to the **Connections** section 

6. Click the **Create connection** button.
7. Click **S3 compatible object storage - v1** from the *connection-type* drop-down list.
8. Enter the following details into the form:  
   Connection name: **rag-s3-storage**  
   Access key: **minio**  
   Secret key: **minio1234**  
   Endpoint: **minio.minio.svc.cluster.local:9000**  
   Region: **none**  
   Bucket: **rag-docs**  

Review the information you have entered:

![./images/create-workbench-2.png](images/create-workbench-2.png)

9. Click **Create**.

⚠️ **Note:** You may receive a warning from your browser informing you of a weak password. You can safely ignore that warning.


10. Click **Create workbench**

OpenShift AI creates and starts the workbench.

![./images/create-workbench-3.png](images/create-workbench-3.png)

Wait for the status to change to *Running*.  

The workbench has now been created. You will now open the workbench, which will launch **JupyterLab**, your IDE for the lab.  

---

# Open the Jupyter notebook

1. Click **rag-workbench** to open **JupyterLab**.  
   In the login dialog box, enter the same credentials you used to log into OpenShift at the start of this lab.

2. Click **Login**  
   OpenShift AI launches JupyterLab.  

With JupyterLab now running, you will now download all of the lab materials:  
3. Click the **Git** button in the toolbar on the left side of JupyterLab.  

![./images/jupyter-lab.png](images/jupyter-lab.png)  

4. Click **Clone a Repository**  
   OpenShift AI prompts you to enter the repository URL and other options.  

5. Copy and paste the following into the *URI of the remote Git repository* text box: `https://github.com/odh-labs/rhoai-roadshow-v2.git`  
6. Click **Include submodules**.  

![images/clone-git-repo-2.png](images/clone-git-repo-2.png) 

7. Click **Clone**.  
   JupyterLab copies the source code from GitHub into your Workspace.

![images/clone-git-repo-3.png](images/clone-git-repo-3.png) 

8. In the *File Explorer* panel, navigate into the directory: `/rhoai-roadshow-v2`  

![images/clone-git-repo-4.png](images/clone-git-repo-4.png)  

9. Double click `2-rag.jupyterlab-workspace` to open the workspace for this activity.  
   JupyterLab opens the workspace. All of the notebooks you will use are visible in the *File Explorer*.  


![images/clone-git-repo-4.png](images/clone-git-repo-5.png)  

When done, you have successfully connected to your environment and this completes this activity. Click the link below to move to the next activity 'Validate the lab environment'.