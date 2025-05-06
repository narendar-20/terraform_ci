#!/bin/bash

# Fetch the IP addresses from Terraform output
frontend_ip=$(terraform output -raw frontend_ip)
backend_ip=$(terraform output -raw backend_ip)

# Create the Ansible inventory file dynamically
cat > inventory.ini <<EOF
[frontend]
c8.local ansible_host=$frontend_ip

[backend]
u21.local ansible_host=$backend_ip

[frontend:vars]
nginx_backend_ip=$backend_ip

[backend:vars]
netdata_port=19999
EOF

echo "Inventory file generated successfully!"
