#!/bin/bash
set -euo pipefail

# Install Docker
sudo apt-get update
sudo apt-get install -y docker.io

# Install kubectl
sudo curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Configure kubectl to connect to the EKS cluster
sudo mkdir -p "$HOME/.kube"
sudo cp /etc/kubernetes/kubelet.conf "$HOME/.kube/config"
sudo chown "$(id -u):$(id -g)" "$HOME/.kube/config"

# Verify installation and connection to the cluster
echo "Verifying kubectl installation and connection to the cluster..."
kubectl version --short
kubectl get nodes

# NETWORKING
# wireless dependencies
# sudo apt install aircrack-ng
# sudo apt install bettercap
# sudo apt install nmap

# Clean up
rm kubectl


# Define repository URLs here
# repository_urls=(
#     "your-repository-url-1"
#     "your-repository-url-2"
#     # Add more repository URLs as needed
# )

# region="$(echo "$repository_url" | cut -d. -f4)"
# image_name="$(echo "$repository_url" | cut -d/ -f2)"

# Authenticate Docker with ECR (assuming you have AWS CLI installed and configured)
# aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$repository_url"

# Authenticate Docker with ECR (assuming you have AWS CLI installed and configured)
# for repository_url in "${repository_urls[@]}"; do
#     region="$(echo "$repository_url" | cut -d. -f4)"
#     aws ecr get-login-password --region "$region" | docker login --username AWS --password-stdin "$repository_url"

#     # Pull the latest image from ECR
#     sudo docker pull "$repository_url:$tag"

#     # Run the container
#     sudo docker run -d "$repository_url:$tag"
# done

# # Verify the container is running
# sudo docker ps