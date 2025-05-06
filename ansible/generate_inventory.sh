#!/bin/bash

# Get IPs from Terraform output
FRONTEND_IP=$(terraform -chdir=../terraform output -raw frontend_ip)
BACKEND_IP=$(terraform -chdir=../terraform output -raw backend_ip)

# Generate the inventory
cat <<EOF > inventory.ini
[frontend]
$FRONTEND_IP ansible_user=ec2-user ansible_ssh_private_key_file=$ANSIBLE_KEY_FILE

[backend]
$BACKEND_IP ansible_user=ubuntu ansible_ssh_private_key_file=$ANSIBLE_KEY_FILE
EOF
