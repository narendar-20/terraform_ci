#!/usr/bin/env python3
import json

def main():
    with open("frontend_ip.txt") as f:
        frontend_ip = f.read().strip()
    with open("backend_ip.txt") as f:
        backend_ip = f.read().strip()

    inventory = {
        "frontend": {
            "hosts": [frontend_ip],
        },
        "backend": {
            "hosts": [backend_ip],
        },
        "_meta": {
            "hostvars": {
                frontend_ip: {"ansible_user": "ec2-user"},
                backend_ip: {"ansible_user": "ubuntu"},
            }
        }
    }

    # Ensure keys in _meta are the IP addresses, not variable names
    inventory['_meta']['hostvars'][frontend_ip] = {"ansible_user": "ec2-user"}
    inventory['_meta']['hostvars'][backend_ip] = {"ansible_user": "ubuntu"}

    print(json.dumps(inventory, indent=2))

if __name__ == "__main__":
    main()
