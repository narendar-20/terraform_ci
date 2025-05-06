pipeline {
    agent any

    tools {
        terraform 'terraform'  // name from Global Tool Configuration
        ansible 'ansible'      // name from Global Tool Configuration
    }

    environment {
        AWS_DEFAULT_REGION = 'us-east-1' // adjust if needed
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
                dir('ansible') {
                    sh 'chmod +x generate_inventory.sh'
                    sh './generate_inventory.sh > inventory.ini'
                }
            }
        }

        stage('Run Ansible Playbooks') {
            steps {
                // For Backend (Ubuntu)
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'ubuntu-ssh-key',  // Referencing Ubuntu credentials ID
                    keyFileVariable: 'SSH_PRIVATE_KEY'
                )]) {
                    dir('ansible') {
                        sh '''
                            chmod 600 $SSH_PRIVATE_KEY
                            export ANSIBLE_HOST_KEY_CHECKING=False

                            # Run backend playbook with 'ubuntu' user
                            ansible-playbook -i inventory.ini playbook_backend.yml --private-key=$SSH_PRIVATE_KEY -u ubuntu
                        '''
                    }
                }

                // For Frontend (AWS EC2)
                withCredentials([sshUserPrivateKey(
                    credentialsId: 'aws-ec2-ssh-key',  // Referencing AWS EC2 credentials ID
                    keyFileVariable: 'EC2_SSH_PRIVATE_KEY'
                )]) {
                    dir('ansible') {
                        sh '''
                            chmod 600 $EC2_SSH_PRIVATE_KEY
                            export ANSIBLE_HOST_KEY_CHECKING=False

                            # Run frontend playbook with 'ec2-user'
                            ansible-playbook -i inventory.ini playbook_frontend.yml --private-key=$EC2_SSH_PRIVATE_KEY -u ec2-user
                        '''
                    }
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
