#!/bin/bash

# Exit on any error
set -e

# Define path to private key and inventory
SSH_KEY_PATH="/var/lib/jenkins/.ssh/jenkins_key"
INVENTORY_FILE="./ansible/inventory.ini"

# Navigate to terraform directory to extract outputs
cd terraform

# Extract IPs from Terraform output
BACKEND_IP=$(terraform output -raw backend_ip)
FRONTEND_IP=$(terraform output -raw frontend_ip)

# Move back to root
cd ..

# Generate inventory.ini
echo "Generating inventory.ini with backend IP: $BACKEND_IP and frontend IP: $FRONTEND_IP"

cat <<EOL > $INVENTORY_FILE
[backend]
$BACKEND_IP ansible_user=ubuntu ansible_ssh_private_key_file=$SSH_KEY_PATH

[frontend]
$FRONTEND_IP ansible_user=ec2-user ansible_ssh_private_key_file=$SSH_KEY_PATH
EOL

echo "inventory.ini generated successfully at $INVENTORY_FILE"

# Optional: Run Ansible Playbooks
echo "Running backend playbook..."
ansible-playbook -i $INVENTORY_FILE ansible/playbook_backend.yml --private-key=$SSH_KEY_PATH -u ubuntu

echo "Running frontend playbook..."
ansible-playbook -i $INVENTORY_FILE ansible/playbook_frontend.yml --private-key=$SSH_KEY_PATH -u ec2-user
