#!/bin/bash
set -o pipefail
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly ORANGE='\033[38;5;214m'
readonly NC='\033[0m' # No Color

if [ -f "${KUBECONFIG_F}" ]; then
    KUBECONFIG=${KUBECONFIG_F}
fi

cd ${WORK_DIR} && git clone https://github.com/eformat/rhoai-policy-collection.git
cd ${WORK_DIR}/rhoai-policy-collection

echo "💥 Working directory is: $(pwd)" | tee -a output.log

bootstrap_operators() {
    echo "💥 Running Bootstrap Operators ..." | tee -a output.log
    local i=0
    kustomize build --enable-helm gitops/bootstrap | oc apply -f-
    until [ "${PIPESTATUS[1]}" == 0 ]
    do
        echo -e "${GREEN}Waiting for 0 rc from oc commands.${NC}" | tee -a output.log
        ((i=i+1))
        if [ $i -gt 100 ]; then
            echo -e "🕱${RED}Failed - oc never ready?.${NC}" | tee -a output.log
            exit 1
        fi
        sleep 15
        kustomize build --enable-helm gitops/bootstrap | oc apply -f-
    done
    echo "💥 Bootstrap Operators Done" | tee -a output.log
}
bootstrap_operators

bootstrap_cr() {
    echo "💥 Running Bootstrap CR ..." | tee -a output.log
    local i=0
    oc apply -f gitops/bootstrap/setup-cr.yaml | tee -a output.log
    until [ "${PIPESTATUS[0]}" == 0 ]
    do
        echo -e "${GREEN}Waiting for 0 rc from oc commands.${NC}" | tee -a output.log
        ((i=i+1))
        if [ $i -gt 100 ]; then
            echo -e "🕱${RED}Failed - oc never ready?.${NC}" | tee -a output.log
            exit 1
        fi
        sleep 15
        oc apply -f gitops/bootstrap/setup-cr.yaml | tee -a output.log
    done
    echo "💥 Bootstrap CR Done" | tee -a output.log
}
bootstrap_cr

wait () {
    echo "💥 Waiting for operators ..." | tee -a output.log
    local i=0
    oc wait --for=condition=Ready pod -l app.kubernetes.io/name=global-policy-server -n openshift-gitops --timeout=600s && \
    oc wait --for=condition=Ready pod -l name=cert-manager-operator -n cert-manager-operator --timeout=600s && \
    oc wait --for=condition=Ready pod -l name=multiclusterhub-operator -n open-cluster-management --timeout=600s
    until [ "$?" == 0 ]
    do
        echo -e "${GREEN}Waiting for 0 rc from oc commands.${NC}"
        ((i=i+1))
        if [ $i -gt 500 ]; then
            echo -e "🕱${RED}Failed - oc never ready?.${NC}"
            exit 1
        fi
        sleep 5
        oc wait --for=condition=Ready pod -l app.kubernetes.io/name=global-policy-server -n openshift-gitops --timeout=600s && \
        oc wait --for=condition=Ready pod -l name=cert-manager-operator -n cert-manager-operator --timeout=600s && \
        oc wait --for=condition=Ready pod -l name=multiclusterhub-operator -n open-cluster-management --timeout=600s
    done
    echo "💥 Waiting for operators Done" | tee -a output.log
}
wait

# configure
echo "💥 Configure" | tee -a output.log
./gitops/bootstrap/users.sh 2>&1 | tee -a output.log
./gitops/bootstrap/storage.sh | tee -a output.log
./gitops/bootstrap/certificates.sh 2>&1 | tee -a output.log
