#!/bin/bash

argoPass=$(kubectl -n argocd get secret argocd-initial-admin-secret -ogo-template='{{.data.password | base64decode}}')
echo "$argoPass"
