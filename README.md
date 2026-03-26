# AgentTandem

LLM Agent as a Service — local Kubernetes + ArgoCD GitOps pattern.

## Stack

| Tool | Role |
|------|------|
| `kind` | Local Kubernetes cluster (runs inside Docker) |
| `ArgoCD` | GitOps sync engine — watches Git, deploys manifests |
| `Kubernetes Job` | Ephemeral agent runner with auto-cleanup |
| `Python` | Agent runtime (calls LLM API) |

## Project Structure

```
AgentTandem/
├── agent/
│   ├── main.py           # LLM agent logic
│   ├── requirements.txt
│   └── Dockerfile
├── manifests/
│   ├── job.yaml          # Kubernetes Job (agent runner)
│   └── secret.yaml       # API key secret
├── argocd/
│   └── application.yaml  # ArgoCD Application manifest
├── kind/
│   └── cluster.yaml      # kind cluster config
├── scripts/
│   ├── phase1_cluster.sh # Install kind + create cluster
│   └── phase1_argocd.sh  # Install ArgoCD into cluster
└── README.md
```

## Phases

- [ ] Phase 1 — Local K8s cluster + ArgoCD
- [ ] Phase 2 — Agent container (Python + Dockerfile)
- [ ] Phase 3 — Kubernetes manifests (Job + Secret)
- [ ] Phase 4 — ArgoCD GitOps wiring
- [ ] Phase 5 — Trigger pattern (Argo Events / webhook)

## Quick Start

```bash
# 1. Create cluster
kind create cluster --name agenttandem --config kind/cluster.yaml

# 2. Install ArgoCD
bash scripts/phase1_argocd.sh

# 3. Port-forward ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Open https://localhost:8080 — user: admin
```
