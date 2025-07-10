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
    oc login -u admin -p ${ADMIN_PASSWORD} --server=https://api.sno.${BASE_DOMAIN}:6443
    until [ "$?" == 0 ]
    do
        echo -e "${GREEN}Waiting for 0 rc from oc commands.${NC}" 2>&1 | tee -a output.log
        ((i=i+1))
        if [ $i -gt 100 ]; then
            echo -e "🕱${RED}Failed - oc login never ready?.${NC}" 2>&1 | tee -a output.log
            exit 1
        fi
        sleep 10
        oc login -u admin -p ${ADMIN_PASSWORD} --server=https://api.sno.${BASE_DOMAIN}:6443
    done
    echo "💥 Login to OpenShift Done" | tee -a output.log
}
login

# install apps
echo "💥 Install apps" | tee -a output.log
./gitops/bootstrap/install.sh -d 2>&1 | tee -a output.log

# create console links
echo "💥 Install console links" | tee -a output.log
cat gitops/bootstrap/console-links.yaml | envsubst | oc apply -f-

# setup vault
echo "💥 Setup Vault" | tee -a output.log
cat gitops/bootstrap/vault-secret.yaml | envsubst | oc apply -f-
./gitops/bootstrap/vault-setup.sh -d 2>&1 | tee -a output.log

# setup efs
echo "💥 Setup EFS" | tee -a output.log
./gitops/bootstrap/storage-create-efs.sh -d 2>&1 | tee -a output.log

# final check
echo "💥 Checking install..." | tee -a output.log
./gitops/bootstrap/check-install.sh 2>&1 | tee -a output.log
