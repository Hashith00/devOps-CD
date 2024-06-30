CD
pipeline {
    agent any

    stages {
        stage('Run ansible file') {
            steps {
                script {
                    // Print debugging information
                    sh 'echo "Running Ansible playbook with key ID: ansible-key-5"'
                    sh 'ansible --version'
                    sh 'cat /usr/devOps-CD/ansible_hosts'
                }
                ansiblePlaybook credentialsId: 'ec2-default', disableHostKeyChecking: true, installation: 'Ansible', inventory: '/usr/devOps-CD/ansible_hosts', playbook: '/usr/devOps-CD/playbooks/cd.yaml', vaultTmpPath: ''
            }
        }
    }
}



-- CI
pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'vojofront'
        DOCKER_TAG = 'latest'
        DOCKER_REPO = 'hashith/node_devops'
    }

    stages {
        stage('Checkout') {
            steps {
               git branch: 'main', url: 'https://github.com/Hashith00/Vojo_admin_frontend.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_REPO}:${DOCKER_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                        sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                    }
                    sh "docker push ${DOCKER_REPO}:${DOCKER_TAG}"
                }
            }
        }
    }
    post {
        success {
            build job: 'CD'
        }
    }
    

}