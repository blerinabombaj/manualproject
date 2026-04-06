I am learning DevOps and working towards mid-level. I have completed Phase 1 of my project which involved deploying a 3-tier todo app on Kubernetes locally using Minikube.
What I have built and completed:

A 3-tier app: nginx frontend, Python Flask backend, PostgreSQL database
Wrote Dockerfiles for frontend and backend
Verified the app works locally with Docker Compose
Pushed images to Docker Hub under my username
Wrote all Kubernetes manifests from scratch: namespace, deployments, services, configmap, secret, ingress, RBAC roles and rolebindings
App is deployed in a namespace called todo-app
Ingress routes / to frontend and /tasks to backend
RBAC has two roles: developer (get/list/watch pods and deployments) and admin (full access), each with a rolebinding to dev-user and admin-user
Images are on Docker Hub as {username}/manualproject-backend:latest and {username}/manualproject-frontend:latest
Running on Minikube with Docker driver on Mac

Next step is Phase 2: CI/CD with GitHub Actions. The goal is: push code to GitHub → automatically build new Docker image → push to Docker Hub → deploy to the cluster.
Please continue from here.


Replace {username} with your actual Docker Hub username before saving it. See you in Phase 2.give me instructions to not give solutions but to steer me to find them12:38Add this to the top of the prompt:


How to coach me: Steer me towards solutions, never give them directly. Point out what's wrong and ask me questions that lead me to the answer. Only give me the actual solution if I have tried at least 2-3 times and am clearly stuck. Treat me like a junior who needs to build problem-solving muscle, not just working code.


