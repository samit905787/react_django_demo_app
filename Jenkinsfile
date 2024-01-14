pipeline {
     agent any
        environment {
        registryName = "testdatadaanrepo"
        registryUrl = "testdatadaanrepo.azurecr.io"
        registryCredential = "ACR"
        dockerImage = 'react_django_demo_app'
	webAppResourceGroup = 'Rg-Amit'
	webAppName = 'testdatadaanapp'
    }
stages {

    stage('checkout') {
        steps {
            checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/samit905787/react_django_demo_app.git']])
            }
    }

    stage ('build image') {
        steps {        
            script {
                dockerImage = docker.build("${dockerImage}:${env.BUILD_ID}")
                }      
            }
    }

    stage('push to ACR') {
        steps{   
            script {    
                docker.withRegistry( "http://${registryUrl}", 'registryCredential' ) {
                dockerImage.push()
                }
            }
        }
    }
    
    stage('deploy to appservice') {
        steps {
            withCredentials([
            string(credentialsId: 'app-id-1', variable: 'username'),
            string(credentialsId: 'tenant-id-1', variable: 'tenant'),
            string(credentialsId: 'app-id-pass-1', variable: 'password')
            ]) {
            sh """
                /usr/local/bin/az login --service-principal -u ${username} -p ${password} --tenant ${tenant}
                /usr/local/bin/az  webapp config container set --name testdatadaanapp --resource-group Rg-Amit  --docker-custom-image-name=testdatadaanrepo.azurecr.io/react_django_demo_app:${env.BUILD_ID}
                """
            }
        }
    }
    
}
    }
