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
stage('Checkout') {
    description: 'Checkout source code from the repository'
    steps {
        checkout([$class: 'GitSCM', branches: [[name: '*/main']], userRemoteConfigs: [[url: 'https://github.com/samit905787/react_django_demo_app.git']]])
    }
}

stage('Build Image') {
    description: 'Build Docker image'
    steps {
        script {
            dockerImage = docker.build("${registryName}:${env.BUILD_ID}")
        }
    }
}

stage('Push to ACR') {
    description: 'Push Docker image to Azure Container Registry'
    steps {
        script {
            docker.withRegistry("http://${registryUrl}", registryCredential) {
                dockerImage.push()
            }
        }
    }
}

stage('Deploy to AppService') {
    description: 'Deploy Docker image to Azure App Service'
    steps {
        withCredentials([
            string(credentialsId: 'app-id-1', variable: 'username'),
            string(credentialsId: 'tenant-id-1', variable: 'tenant'),
            string(credentialsId: 'app-id-pass-1', variable: 'password')
        ]) {
            sh """
                /usr/local/bin/az login --service-principal -u ${username} -p ${password} --tenant ${tenant}
                /usr/local/bin/az webapp config container set --name ${webAppName} --resource-group ${webAppResourceGroup} --docker-custom-image-name=${registryUrl}/${dockerImage}:${env.BUILD_ID}
            """
        }
    }
}
    
}
    }
