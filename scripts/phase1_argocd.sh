#!/bin/bash
set -e
echo "==> Creating argocd namespace..."
kubectl create namespace argocd

echo "==> Installing ArgoCD..."
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "==> Waiting for ArgoCD server (~60s)..."
kubectl wait --for=condition=available --timeout=120s deployment/argocd-server -n argocd

echo "==> Admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
echo ""
echo ""
echo "Run in a new terminal:"
echo "  kubectl port-forward svc/argocd-server -n argocd 8080:443"
echo "Then open: https://localhost:8080  (user: admin)"
