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
