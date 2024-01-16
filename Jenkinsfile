pipeline {
    agent any

    environment {
        // Define your deployment details
        vmHost = 'deployvm'
        vmUser = 'azureuser'
        vmPassword = 'Welcome@12345'
        appPath = '/home/azureuser/app'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout your source code from version control
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/samit905787/react_django_demo_app.git']])
            }
        }

        stage('Build and Collect Artifacts') {
            steps {
                // Build your React and Django applications
                script {
                    sh 'npm install' // Adjust this based on your React app structure
                    sh 'npm run build' // Adjust this based on your React app build script

                    sh 'pip install -r requirements.txt' // Adjust this based on your Django app structure
                    // You may need to run migrations and collect static files for Django

                    // Collect artifacts to be deployed
                    archiveArtifacts artifacts: '**/build/**', fingerprint: true
                    archiveArtifacts artifacts: '**/dist/**', fingerprint: true
                    archiveArtifacts artifacts: '**/requirements.txt', fingerprint: true
                }
            }
        }

        stage('Deploy to VM') {
            steps {
                // Copy artifacts to VM
                script {
                    sshagent(['your-ssh-credentials-id']) {
                        sh "scp -r -o StrictHostKeyChecking=no build dist requirements.txt ${vmUser}@${vmHost}:${appPath}"
                    }
                }
            }
        }

        stage('Configure and Start App') {
            steps {
                // Configure and start your application on VM
                script {
                    sshagent(['your-ssh-credentials-id']) {
                        sh "ssh -o StrictHostKeyChecking=no ${vmUser}@${vmHost} 'cd ${appPath} && npm install && python manage.py migrate && python manage.py runserver'"
                    }
                }
            }
        }
    }
}
