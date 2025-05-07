pipeline {
    agent any
    tools {
        terraform 'terraform'
        ansible 'ansible'
    }
    environment {
        AWS_DEFAULT_REGION = 'us-east-2'
    }

    stages {
        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/narendar-20/terraform_ci.git'
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[ 
                    $class: 'AmazonWebServicesCredentialsBinding', 
                    credentialsId: 'narendarp', 
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

        stage('Generate Inventory') {
            steps {
                dir('ansible') {
                    sh 'chmod +x generate_inventory.sh'
                    sh './generate_inventory.sh'
                }
            }
        }

        stage('Configure VMs') {
            steps {
                withCredentials([sshUserPrivateKey(credentialsId: 'narendar-ubuntu', keyFileVariable: 'UBUNTU_KEY')]) {
                    withCredentials([sshUserPrivateKey(credentialsId: 'narendar-ec2', keyFileVariable: 'AMAZON_KEY')]) {
                        dir('ansible') {
                            sh '''
                                chmod 600 $UBUNTU_KEY $AMAZON_KEY
                                export ANSIBLE_HOST_KEY_CHECKING=False

                                ansible-playbook -i inventory.ini playbook_backend.yml --private-key=$UBUNTU_KEY -u ubuntu
                                ansible-playbook -i inventory.ini playbook_frontend.yml --private-key=$AMAZON_KEY -u ec2-user
                            '''
                        }
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment and configuration complete!'
        }
        failure {
            echo '❌ Something went wrong.'
        }
    }
}
