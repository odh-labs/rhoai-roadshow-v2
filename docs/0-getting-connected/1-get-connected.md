# 💁 Introduction

This workshop uses JupyterLab for most of the activities. In this exercise we will:
1. Connect to the workshop environment
2. Create the OpenShift AI **Project** that you will use for the entire workshop.
3. Create a **Workbench** for you to do your work
3. Get familiar with the JupyterLab environment

# Login to OpenShift AI

Your instructor will supply you with a link that you will use to login to your OpenShift AI cluster.

1. Open the OpenShift AI console using the url provided by your instructor.  
2. Use the following credentials to login to OpenShift AI:  
      **Username:** *admin*  
      **Password:** *password* (You will be provided with the password on the day.)
3. Click **Login**  
   OpenShift AI displays the main console.   

![./images/create-project.png](images/create-project.png)

# Create a project

1. Click the **Create project** button on the top right of the display.
2. Type `ai-roadshow` in the **Name** text box.

![./images/create-project-2.png](images/create-project-2.png)  

3. Click **Create**
   OpenShift AI creates an empty project.

![./images/create-workbench-0.png](images/create-workbench-0.png)  

# Create a workbench

4. Select the `ai-roadshow` data science project.

![./images/create-workbench.png](images/create-workbench.png)

5. Enter the following details into the **Create workbench** form:

   Name: **getting-connected**  
   Image Selection: **Minimal Python**  
   Version: **2025.1 (Recommended)**  
   Hardware profile: **Small**  

   Leave all other settings as defaults.

![./images/create-workbench-1.png](images/create-workbench-1.png)

   Review the information you have entered:

6. Click **Create workbench**

OpenShift AI creates and starts the workbench.

![./images/create-workbench-3.png](images/create-workbench-2.png)

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