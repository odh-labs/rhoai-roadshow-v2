# ansible roles

💊 Install the `rhoai-roadshow` using ansible. 💊

This takes approx ~70-120 minutes to complete.

If you are looking to set the roadshow up for a larger audience, there is now a [Hive ClusterPool based install](https://github.com/eformat/rhoai-cluster-pool) which may be better suited than the all-in-one version described below.

## Prerequsites

1. Order an `Getting to know Red Hat OpenShift AI Workshop` for yourself from this catalog item [demo.redhat.com](https://catalog.demo.redhat.com/catalog?search=Getting+to+know+Red+Hat+OpenShift+AI+Workshop)

    Once you have the workshop I recommend `Stopping it` in demo redhat com - this prevents the environment shutting down prematurely (and you running into ~24hr OpenShift install certificate issues).

    - You need to install from a rhel/fedora linux laptop with working ansible, python3, bash, kustomize, helm, htpasswd, oc - else use the `toolbox`/`podman` image below.
    - You need your Red Hat pull secret for OpenShift installation.
    - You need reliable internet access whilst the install is happening.
    - You need to use an AWS Region where L4 Nvidia GPU's are available - `us-east` is cheapest with great capacity.
    - Not tested on MAC.OSX, sno-for-spot will work OK, but dunno about the other bits.

2. You can install it from a [fedora toolbox](https://github.com/eformat/toolbox) that has the required tools baked it.

    ```bash
    toolbox create --image quay.io/eformat/toolbox:latest sno-test
    toolbox enter sno-test
    ```

    Create a venv inside the toolbox (python 3.8+ required)

    ```bash
    python3.13 -m venv venv
    source venv/bin/activate
    ```

3. OR you can use podman directly

    ```bash
    mkdir -p ~/tmp/lab
    podman run -it -v ~/tmp/lab:/root:z quay.io/eformat/toolbox:latest bash
    cd /root
    ```

4. Clone the Codebase

    ```bash
    git clone https://github.com/odh-labs/rhoai-roadshow-v2
    ```

    and cd into it.

    ```bash
    cd rhoai-roadshow-v2/src/ansible
    ```

## Install all in one go

Create AWS config:

```bash
mkdir -p ~/.aws
```

```yaml
# vi ~/.aws/credentials
[sno-test]
aws_access_key_id = A...      # change this (available from the lab instructions page in demo redhat com)
aws_secret_access_key = o...  # change this (available from the lab instructions page in demo redhat com)

# vi ~/.aws/config
[profile sno-test]
region=us-east-2    # matches the region you wish to install SNO into
output=json
```

If using podman copy your ~/.ssh/id_rsa.pub and ~/tmp/pull-secret files into your container.

### Scripted Environment Configuration Method:
Use the `setup-env.sh` script to create the environment configuration file (`env.txt`).

```bash
./setup-env.sh
```

Review the environment variables iand AWS config are correct:

```bash
cat env.txt

cat ~/.aws/credentials

cat ~/.aws/config
```

Define the environment variables:

```bash
source env.txt
```

### Manual Environment Configuration Method
Export in your environment.

```bash
export AWS_PROFILE=sno-test                  # must match aws config
export AWS_DEFAULT_REGION=us-east-2          # change this to suit instance type
export AWS_DEFAULT_ZONES=["us-east-2a"]      # change this to suit
export AWS_ACCESS_KEY_ID=...      # change this (available from the lab instructions page in demo redhat com)
export AWS_SECRET_ACCESS_KEY=...  # change this (available from the lab instructions page in demo redhat com)
export CLUSTER_NAME=sno           # can be anything, but leave as sno unless you need to change it
export BASE_DOMAIN=sandbox3000.opentlc.com    # (available from the lab instructions page in demo redhat com)
export PULL_SECRET=~/tmp/pull-secret          # NOTE THIS IS A FILE - download your pull secret here https://console.redhat.com/openshift/downloads#tool-pull-secret
export SSH_KEY=$(cat ~/.ssh/id_rsa.pub)       # NOTE THIS IS A FILE
export INSTANCE_TYPE=g6.8xlarge   # 24GB L4 Nvidia, 32 vCPUs, 128 GiB of memory and 25 Gibps of bandwidth ~$2 per hour
export ROOT_VOLUME_SIZE=400       # can be anything, but leave as is unless you need to change it
export OPENSHIFT_VERSION=4.19.11  # change this we will keep this working with the latest GA version
export ADMIN_PASSWORD=password    # change this for your admin user
export EMAIL=your@email.com       # change this for lets encrypt certs admin email
export ANSIBLE_VAULT_SECRET=..    # change this to the ansible secret for vault-sno (available from the lab instructions page in demo redhat com)
```

### Running the installation

Run ansible to install environment in one go.

```bash
ansible-playbook -i hosts rhoai-roadshow.yaml
```

The log output can be tailed to follow the install progress.

```yaml
TASK [sno-on-spot : debug] ***************************************************************
ok: [localhost] => {
    "msg": [
        "Follow the install progress",
        "tail -f /tmp/ansible.fb3ma5ra/output.log"
    ]
}
```

The OpenShift install logs (detailed) can be tailed here.

```yaml
tail -f /tmp/ansible.fb3ma5ra/cluster/.openshift_install.log
```

To destroy your cluster:

```bash
cd /tmp/ansible.fb3ma5ra
openshift-install destroy cluster --dir=cluster
```

There are 3 roles with matching folder names:

1. `sno-on-spot` - Cluster Install - if this fails, its usually best to diagnose (e.g. no availability for your instance type), destroy the cluster and reinstall fresh.

2. `cluster-config` - Configures the base cluster - role is re-runnable.

    ```bash
    export KUBECONFIG=/path/to-kubeconfig
    oc login -u admin -p ${ADMIN_PASSWORD} --server=https://api.sno.${BASE_DOMAIN}:6443
    ansible-playbook -i hosts role_runner.yml -e role=cluster-config
    ```

3. `apps` - Deploys ALL the applications using Policy-as-Code and GitOps - role is re-runnable.

    ```bash
    export KUBECONFIG=/path/to-kubeconfig
    oc login -u admin -p ${ADMIN_PASSWORD} --server=https://api.sno.${BASE_DOMAIN}:6443
    ansible-playbook -i hosts role_runner.yml -e role=apps
    ```

Login to your environment.

```bash
oc login -u admin -p ${ADMIN_PASSWORD} --server=https://api.sno.${BASE_DOMAIN}:6443
```

Keep a copy of your `/tmp/ansible.xxx` folder for future OpenShift cluster uninstalls e.g.

```bash
mv /tmp/ansible.xxx ~/sno-test
```

You will also find a print out of the Hashi Vault unseal + root tokens in the log files (keep these safe).

```bash
grep -C5 Unseal /tmp/ansible.xxx/rhoai-policy-collection/output.log
```
