BASE="/Users/wolfisher/项目/Agentic/AgentTandem"
mkdir -p $BASE/{agent,manifests,argocd,scripts,kind}

# README
cat > $BASE/README.md << 'EOF'
# AgentTandem

LLM Agent as a Service — local K8s + ArgoCD GitOps pattern.

## Stack
- `kind` — local Kubernetes cluster (inside Docker)
- `ArgoCD` — GitOps sync engine
- `Kubernetes Job` — ephemeral agent runner (auto-cleanup)
- `Python` — agent runtime

## Structure
AgentTandem/
├── agent/       # Agent source + Dockerfile
├── manifests/   # K8s Job, Secret manifests
├── argocd/      # ArgoCD Application manifest
├── kind/        # kind cluster config
└── scripts/     # Setup scripts
EOF

# kind cluster config
cat > $BASE/kind/cluster.yaml << 'EOF'
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: agenttandem
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30080
        hostPort: 30080
        protocol: TCP
EOF

# Phase 1 cluster script
cat > $BASE/scripts/phase1_cluster.sh << 'EOF'
#!/bin/bash
set -e
echo "==> Installing kind + kubectl..."
brew install kind kubectl

echo "==> Creating cluster..."
kind create cluster --name agenttandem --config ../kind/cluster.yaml

echo "==> Verifying..."
kubectl cluster-info --context kind-agenttandem
kubectl get nodes
EOF

# Phase 1 ArgoCD script
cat > $BASE/scripts/phase1_argocd.sh << 'EOF'
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
EOF

chmod +x $BASE/scripts/*.sh
echo "✅ AgentTandem project created at $BASE"
ls -R $BASE