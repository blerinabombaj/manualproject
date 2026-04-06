I am learning DevOps working towards mid-level. 
I have completed the following:

PHASE 1 - Kubernetes locally on Minikube:
- 3-tier app: nginx frontend, Python Flask backend, PostgreSQL
- Dockerfiles for frontend and backend
- All Kubernetes manifests written from scratch: namespace, 
  deployments, services, configmap, secret, ingress, RBAC
- App runs in namespace called todo-app
- Ingress routes / to frontend and /tasks to backend
- RBAC: developer and admin roles with rolebindings

PHASE 2 - Helm:
- Converted all raw manifests into a Helm chart
- Chart lives in helm/ folder
- values.yaml controls all configurable values
- Images tagged with git commit SHA

PHASE 3 - CI/CD with GitHub Actions:
- Pipeline triggers on push to main
- Builds and pushes frontend and backend images to Docker Hub
- Tags images with :latest and :github.sha
- Updates values.yaml with new SHA tag

PHASE 4 - GitOps with ArgoCD:
- ArgoCD installed on cluster
- Application resource points to helm/ folder in repo
- ArgoCD watches repo and auto-syncs on every change
- Full GitOps loop working end to end

REPO STRUCTURE:
argocd/application.yaml
backend/app.py, Dockerfile, requirements.txt
frontend/Dockerfile, index.html, nginx.conf
docker-compose.yml
helm/Chart.yaml
helm/templates/backend.yaml, frontend.yaml, postgres.yaml,
  configmap.yaml, secret.yaml, ingress.yaml, 
  namespace.yaml, rbac.yaml
helm/values.yaml
.github/workflows/ci.yml

PHASE 5 - NEXT: Move to AWS with Terraform
Guide me through:
1. What AWS resources to create with Terraform for EKS
2. What changes are needed to the existing files 
   (values.yaml, argocd/application.yaml, ci.yml) 
   to make the deployment work on AWS instead of Minikube
3. How ArgoCD connects to a real cloud cluster
4. How the CI/CD pipeline authenticates to EKS for deployment

Steer me towards solutions, never give them directly. 
Point out what's wrong and ask me questions that lead me 
to the answer. Only give me the actual solution if I have 
tried at least 2-3 times and am clearly stuck. Treat me 
like a junior who needs to build problem-solving muscle, 
not just working code.