pipeline {
    agent any

    environment {
        registryName = "reactdjangodemoimage"
        registryUrl = "reactdjangodemoimage.azurecr.io"
        registryCredential = "ACR"
        dockerImage = 'react_django_demo_app-web'
        webAppResourceGroup = 'Rg-Amit'
        webAppName = 'reactdjangodemoapp'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/samit905787/react_django_demo_app.git']])
            }
        }

        stage('Build Docker image') {
            steps {
                script {
                    dockerImage = docker.build("${dockerImage}:${env.BUILD_ID}")
                }
            }
        }

        stage('Upload Image to ACR') {
            steps {
                script {
                    echo "Using credential ID: ${registryCredential}"
                    withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: registryCredential, usernameVariable: 'ACR_USERNAME', passwordVariable: 'ACR_PASSWORD']]) {
                        docker.withRegistry("https://${registryUrl}", "ACR") {
                            dockerImage.push()
                        }
                    }
                }
            }
        }

        stage('Deploy to AppService') {
            steps {
                withCredentials([
                    string(credentialsId: 'app-id-1', variable: 'username'),
                    string(credentialsId: 'tenant-id-1', variable: 'tenant'),
                    string(credentialsId: 'app-id-pass-1', variable: 'password')
                ]) {
                    sh """
                        /usr/local/bin/az login --service-principal -u ${username} -p ${password} --tenant ${tenant}
                        /usr/local/bin/az webapp config container set --name reactdjangodemoapp --resource-group Rg-Amit --docker-custom-image-name=reactdjangodemoimage.azurecr.io/react_django_demo_app-web:${env.BUILD_ID}
                    """
                }
            }
        }
    }
}
