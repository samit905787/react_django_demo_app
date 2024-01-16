pipeline {
    agent any

    environment {
        vmHost = 'deployvm'
        vmUser = 'azureuser'
        vmCredentials = 'your-ssh-credentials-id'
        appPath = '/home/azureuser/app'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/samit905787/react_django_demo_app.git']])
            }
        }

        stage('Build and Collect Artifacts') {
            steps {
                script {
                    // Build React app
                    sh 'npm install'
                    sh 'npm run build'
                    
                    // Build Django app
                    sh 'pip install -r requirements.txt'
                    
                    // Archive artifacts
                    archiveArtifacts artifacts: '**/build/**', fingerprint: true
                    archiveArtifacts artifacts: '**/dist/**', fingerprint: true
                    archiveArtifacts artifacts: '**/requirements.txt', fingerprint: true
                }
            }
        }

        stage('Deploy to VM') {
            steps {
                script {
                    // Copy artifacts to VM
                    sshagent([vmCredentials]) {
                        sh "scp -r -o StrictHostKeyChecking=no build dist requirements.txt ${vmUser}@${vmHost}:${appPath}"
                    }
                }
            }
        }

        stage('Configure and Start App') {
            steps {
                script {
                    // Configure and start application on VM
                    sshagent([vmCredentials]) {
                        sh "ssh -o StrictHostKeyChecking=no ${vmUser}@${vmHost} 'cd ${appPath} && npm install && python manage.py migrate && python manage.py runserver'"
                    }
                }
            }
        }
    }
}
