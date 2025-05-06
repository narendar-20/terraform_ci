pipeline {
    agent any

    tools {
        terraform 'terraform'  // matches name set in Jenkins → Global Tool Configuration
        ansible 'ansible'      // matches name set in Jenkins → Global Tool Configuration
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1' // change if needed
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/RameshDumala1/terraform_ci.git'
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-credentials',
                    accessKeyVariable: 'AWS_ACCESS_KEY_ID',
                    secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
                ]]) {
                    dir('terraform') {
                        // Initialize Terraform
                        sh 'terraform init'
                        // Apply Terraform configuration
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                script {
                    // Run the inventory.py to generate the inventory.ini dynamically
                    sh 'cd ansible && python3 inventory.py > inventory.ini'
                }
            }
        }

        stage('Run Ansible Playbooks') {
            steps {
                dir('ansible') {
                    // Run Ansible playbooks for backend and frontend
                    sh '''
                        ansible-playbook -i inventory.ini playbook_backend.yml
                        ansible-playbook -i inventory.ini playbook_frontend.yml
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo '❌ Build failed.'
        }
        success {
            echo '✅ CI pipeline completed successfully.'
        }
    }
}
