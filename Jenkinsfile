pipeline {
  agent any

  environment {
    ANSIBLE_INVENTORY = "ansible/inventory.py"
  }

  stages {
    stage('Terraform Init & Apply') {
      steps {
        dir('terraform') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
        }
      }
    }

    stage('Wait for SSH availability') {
      steps {
        sh 'sleep 60'
      }
    }

    stage('Ansible Backend Setup') {
      steps {
        dir('ansible') {
          sh './inventory.py > inventory.json'
          sh 'ansible-playbook -i inventory.json playbook_backend.yml'
        }
      }
    }

    stage('Ansible Frontend Setup') {
      steps {
        dir('ansible') {
          sh './inventory.py > inventory.json'
          sh 'ansible-playbook -i inventory.json playbook_frontend.yml'
        }
      }
    }
  }

  post {
    always {
      echo 'Pipeline complete.'
    }
  }
}