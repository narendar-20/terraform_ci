#!/bin/bash

# Get the Terraform outputs for frontend and backend IPs
FRONTEND_IP=$(terraform -chdir=../terraform output -raw frontend_ip)
BACKEND_IP=$(terraform -chdir=../terraform output -raw backend_ip)

# Generate dynamic inventory file
cat <<EOF > inventory.ini
[frontend]
$FRONTEND_IP ansible_user=ec2-user ansible_ssh_private_key_file=~/.ssh/your-key.pem

[backend]
$BACKEND_IP ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/your-key.pem
EOF
