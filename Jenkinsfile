pipeline {
    agent any

    environment {
        TF_WORKSPACE = 'terraform'
        ANSIBLE_WORKSPACE = 'ansible'
    }

    tools {
        terraform 'terraform'
        ansible 'ansible'
    }

    stages {
        stage('Terraform Init & Apply') {
            steps {
                withEnv(["PATH+TERRAFORM=${tool 'terraform'}/bin"]) {
                    dir("${TF_WORKSPACE}") {
                        sh 'terraform init'
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                withEnv(["PATH+TERRAFORM=${tool 'terraform'}/bin"]) {
                    dir("${ANSIBLE_WORKSPACE}") {
                        withCredentials([
                            sshUserPrivateKey(
                                credentialsId: 'ansible-ssh-key',
                                keyFileVariable: 'ANSIBLE_KEY_FILE',
                                usernameVariable: 'SSH_USER'
                            )
                        ]) {
                            sh './generate_inventory.sh'
                        }
                    }
                }
            }
        }

        stage('Run Ansible Playbooks') {
            steps {
                withEnv(["PATH+ANSIBLE=${tool 'ansible'}/bin"]) {
                    dir("${ANSIBLE_WORKSPACE}") {
                        sh 'ansible-playbook -i inventory.ini playbook_backend.yml'
                        sh 'ansible-playbook -i inventory.ini playbook_frontend.yml'
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ CI pipeline completed successfully.'
        }
        failure {
            echo '❌ Build failed.'
        }
    }
}
