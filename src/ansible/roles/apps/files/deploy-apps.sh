#!/bin/bash
set -o pipefail
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly ORANGE='\033[38;5;214m'
readonly NC='\033[0m' # No Color

cd ${WORK_DIR} && git clone https://github.com/eformat/rhoai-policy-collection.git
cd ${WORK_DIR}/rhoai-policy-collection

echo "💥 Working directory is: $(pwd)" | tee -a output.log

# use login
export KUBECONFIG=~/.kube/config.${AWS_PROFILE}

login () {
    echo "💥 Login to OpenShift..." | tee -a output.log
    local i=0
    oc login -u admin -p ${ADMIN_PASSWORD} --server=https://api.sno.${BASE_DOMAIN}:6443 --insecure-skip-tls-verify=true
    until [ "$?" == 0 ]
    do
        echo -e "${GREEN}Waiting for 0 rc from oc commands.${NC}" 2>&1 | tee -a output.log
        ((i=i+1))
        if [ $i -gt 200 ]; then
            echo -e "🕱${RED}Failed - oc login never ready?.${NC}" 2>&1 | tee -a output.log
            exit 1
        fi
        sleep 10
        oc login -u admin -p ${ADMIN_PASSWORD} --server=https://api.sno.${BASE_DOMAIN}:6443 --insecure-skip-tls-verify=true
    done
    echo "💥 Login to OpenShift Done" | tee -a output.log
}
login

console_links() {
    echo "💥 Install console links" | tee -a output.log
    cat gitops/bootstrap/console-links.yaml | envsubst | oc apply -f-
    until [ "${PIPESTATUS[2]}" == 0 ]
    do
        echo -e "${GREEN}Waiting for 0 rc from oc commands.${NC}" 2>&1 | tee -a output.log
        ((i=i+1))
        if [ $i -gt 50 ]; then
            echo -e "🕱${RED}Failed - console links never done ?.${NC}" 2>&1 | tee -a output.log
            exit 1
        fi
        sleep 10
        cat gitops/bootstrap/console-links.yaml | envsubst | oc apply -f-
    done
    echo "💥 Install console links Done" | tee -a output.log
}

vault_secret() {
    echo "💥 Install vault secret" | tee -a output.log
    cat gitops/bootstrap/vault-secret.yaml | envsubst | oc apply -f-
    until [ "${PIPESTATUS[2]}" == 0 ]
    do
        echo -e "${GREEN}Waiting for 0 rc from oc commands.${NC}" 2>&1 | tee -a output.log
        ((i=i+1))
        if [ $i -gt 50 ]; then
            echo -e "🕱${RED}Failed - vault secret never done ?.${NC}" 2>&1 | tee -a output.log
            exit 1
        fi
        sleep 10
        cat gitops/bootstrap/vault-secret.yaml | envsubst | oc apply -f-
    done
    echo "💥 Install vault secret Done" | tee -a output.log
}

# install apps
echo "💥 Install apps" | tee -a output.log
./gitops/bootstrap/install.sh -d 2>&1 | tee -a output.log

# console links
console_links

# vault secret
vault_secret

# setup vault
echo "💥 Setup Vault" | tee -a output.log
./gitops/bootstrap/vault-setup.sh -d 2>&1 | tee -a output.log

# setup efs
echo "💥 Setup EFS" | tee -a output.log
./gitops/bootstrap/storage-create-efs.sh -d 2>&1 | tee -a output.log

# final check
echo "💥 Checking install..." | tee -a output.log
./gitops/bootstrap/check-install.sh 2>&1 | tee -a output.log

# roadshow clusters dont need to live beyond the roadshow use a fake pull-secret
echo "💥 Remove global pull-secret..." | tee -a output.log
oc delete secret pull-secret -n openshift-config
oc create -f- << EOF
apiVersion: v1
data:
  .dockerconfigjson: eyJhdXRocyI6eyJjbG91ZC5vcGVuc2hpZnQuY29tIjp7ImF1dGgiOiJabUZyWlFvPSIsImVtYWlsIjoiZmFrZUByZWRoYXQuY29tIn0sInF1YXkuaW8iOnsiYXV0aCI6IlptRnJaUW89IiwiZW1haWwiOiJmYWtlQHJlZGhhdC5jb20ifSwicmVnaXN0cnkuY29ubmVjdC5yZWRoYXQuY29tIjp7ImF1dGgiOiJabUZyWlFvPSIsImVtYWlsIjoiZmFrZUByZWRoYXQuY29tIn0sInJlZ2lzdHJ5LnJlZGhhdC5pbyI6eyJhdXRoIjoiWm1GclpRbz0iLCJlbWFpbCI6ImZha2VAcmVkaGF0LmNvbSJ9fX0K
kind: Secret
metadata:
  name: pull-secret
  namespace: openshift-config
type: kubernetes.io/dockerconfigjson
EOF
