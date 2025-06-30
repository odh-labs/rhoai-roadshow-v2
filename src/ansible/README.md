# ansible roles

💊 Install the `rhoai-roadshow` using ansible. 💊

## Prerequsites

Order an `AWS Blank Open Environment` for yourself from this catalog item [demo.redhat.com](https://demo.redhat.com/catalog?search=AWS+Blank)

- You need to install from a rhel/fedora linux laptop with working ansible, python3, bash, kustomize, helm, htpasswd, oc - else use the toolbox
- You need your Red Hat pull secret for OpenShift installation.
- You need reliable internet access.
- You need to use an AWS Region where L4 Nvidia GPU's are available - `us-east` is cheapest with great capacity.
- Not tested on MAC.OSX, sno-for-spot will work OK, but dunno about the other bits.

You can install it from a [fedora toolbox](https://github.com/eformat/toolbox) that has the required tools baked it.

```bash
toolbox create --image quay.io/eformat/toolbox:latest sno-test
toolbox enter sno-test
```

## Install it all in one go

Create AWS config:

```yaml
# ~/.aws/credentials
[sno-test]
aws_access_key_id = A...
aws_secret_access_key = o...

# ~/.aws/config
[profile sno-test]
region=us-east-2
output=json
```

Export in your environment.

```bash
export AWS_PROFILE=sno-test             # must match aws config
export AWS_DEFAULT_REGION=us-east-2     # change this to suit instance type
export AWS_DEFAULT_ZONES=["us-east-2a"] # change this to suit
export AWS_ACCESS_KEY_ID=...      # change this
export AWS_SECRET_ACCESS_KEY=...  # change this
export CLUSTER_NAME=sno
export BASE_DOMAIN=sandbox2585.opentlc.com
export PULL_SECRET=~/tmp/pull-secret  # NOTE THIS IS THE FILE ! ansible messes up the quoting
export SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
export INSTANCE_TYPE=g6.8xlarge # 24GB L4 Nvidia, 32 vCPUs, 128 GiB of memory and 25 Gibps of bandwidth ~$2 per hour
export ROOT_VOLUME_SIZE=400
export OPENSHIFT_VERSION=4.19.1
export ADMIN_PASSWORD=password    # change this for your admin user
export EMAIL=mhepburn@redhat.com  # change this for certs admin
export ANSIBLE_VAULT_SECRET=,..   # change this to the ansible secret for vault-sno
```

Run ansible - each role listed in here.

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

To destroy your cluster:

```bash
cd /tmp/ansible.fb3ma5ra
openshift-install destroy cluster --dir=cluster
```

There are 3 roles with matching folder names:

1. `sno-on-spot` - Cluster Install - if this fails, its usually best to diagnose, destroy the cluster and reinstall fresh.

2. `cluster-config` - Configures the base cluster - role is re-runnable.

    ```bash
    export KUBECONFIG=/path/to-kubeconfig
    oc login -u admin -p ${ADMIN_PASSWORD} -server=https://api.sno.${BASE_DOMAIN}:6443
    ansible-playbook -i hosts role_runner.yml -e role=cluster-config
    ```

3. `apps` - Deploys ALL the applications using Policy-as-Code and GitOps - role is re-runnable.

    ```bash
    export KUBECONFIG=/path/to-kubeconfig
    oc login -u admin -p ${ADMIN_PASSWORD} -server=https://api.sno.${BASE_DOMAIN}:6443
    ansible-playbook -i hosts role_runner.yml -e role=apps
    ```

Login to your environment.

```bash
oc login -u admin -p ${ADMIN_PASSWORD} -server=https://api.sno.${BASE_DOMAIN}:6443
```

## Things to work on

- [ ] `FIXME` - ⚒️ the minio password and secret is egregiously leaked in git - move to vault ⚒️
- [ ] `FIXME` - ⚒️ scale this to (n) workshop users - currently each user has single node of openshift with all the tools ⚒️
