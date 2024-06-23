#!/bin/bash

# Define the file paths in variables
INSTALL_YAML_PATH="$HOME/devops/argocd/argo/install.yaml"
ARGOCD_APP_YAML_PATH="$HOME/devops/argocd/argo/multi-repo.yaml"

# Command to delete the resources in the "argocd" namespace
kubectl delete -n argocd -f "${INSTALL_YAML_PATH}"
kubectl delete -n argocd -f "${ARGOCD_APP_YAML_PATH}"

# Command to delete the "argocd" namespace
kubectl delete namespace argocd