#!/bin/bash

# Read IPs
BACKEND_IP=$(cat backend_ip.txt)
FRONTEND_IP=$(cat frontend_ip.txt)

# Output to inventory.ini with only valid content
cat <<EOF > inventory.ini
[backend]
$BACKEND_IP ansible_user=ubuntu ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/jenkins_key

[frontend]
$FRONTEND_IP ansible_user=ec2-user ansible_ssh_private_key_file=/var/lib/jenkins/.ssh/jenkins_key
EOF

echo "inventory.ini generated successfully."
