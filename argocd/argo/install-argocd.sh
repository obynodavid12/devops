# # #!/bin/bash

# # Define the file paths in variables
# INSTALL_YAML_PATH="$HOME/argocd-demo/argocd/argo/install.yaml"
# ARGOCD_APP_YAML_PATH="$HOME/argocd-demo/argocd/argo/argocd-app.yaml"

# # Command to create a namespace "argocd"
# kubectl create namespace argocd

# # Command to apply the installation YAML file to the "argocd" namespace
# kubectl apply -n argocd -f "${INSTALL_YAML_PATH}"

# # Command to apply the argocd-app YAML file to the "argocd" namespace
# kubectl apply -n argocd -f "${ARGOCD_APP_YAML_PATH}"


#!/bin/bash

# Define the file paths in variables
INSTALL_YAML_PATH="$HOME/devops/argocd/argo/install.yaml"
ARGOCD_APP_YAML_PATH="$HOME/devops/argocd/argo/multi-repo.yaml"

# Check if the namespace "argocd" exists
if kubectl get namespace argocd &> /dev/null; then
    echo "Namespace 'argocd' already exists."
else
    # Command to create a namespace "argocd"
    kubectl create namespace argocd
    echo "Namespace 'argocd' created."
fi

# Command to apply the installation YAML file to the "argocd" namespace
kubectl apply -n argocd -f "${INSTALL_YAML_PATH}"
# kubectl delete -n argocd -f "${INSTALL_YAML_PATH}"

# Command to apply the argocd-app YAML file to the "argocd" namespace
kubectl apply -n argocd -f "${ARGOCD_APP_YAML_PATH}"
# kubectl delete -n argocd -f "${ARGOCD_APP_YAML_PATH}"