#!/bin/bash
set -e
echo "==> Installing kind + kubectl..."
brew install kind kubectl

echo "==> Creating cluster..."
kind create cluster --name agenttandem --config ../kind/cluster.yaml

echo "==> Verifying..."
kubectl cluster-info --context kind-agenttandem
kubectl get nodes
