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
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                sh 'chmod +x generate_inventory.sh'
                sh './generate_inventory.sh'
                sh 'cat ansible/inventory.ini'
            }
        }

        stage('Run Ansible Playbooks') {
            steps {
                dir('ansible') {
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
