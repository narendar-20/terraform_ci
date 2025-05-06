#!/bin/bash

# Get IPs from Terraform output
FRONTEND_IP=$(terraform -chdir=../terraform output -raw frontend_ip)
BACKEND_IP=$(terraform -chdir=../terraform output -raw backend_ip)

# Set paths to private key files
FRONTEND_KEY_PATH="/var/lib/jenkins/.ssh/jenkins_key"  # Private key for ec2-user (Frontend)
BACKEND_KEY_PATH="/var/lib/jenkins/.ssh/jenkins_key1"  # Private key for ubuntu (Backend)

# Generate the inventory.ini file dynamically
cat <<EOF > inventory.ini
[frontend]
$FRONTEND_IP ansible_user=ec2-user ansible_ssh_private_key_file=$FRONTEND_KEY_PATH

[backend]
$BACKEND_IP ansible_user=ubuntu ansible_ssh_private_key_file=$BACKEND_KEY_PATH
EOF

echo "Inventory file generated with IPs and private key paths."
