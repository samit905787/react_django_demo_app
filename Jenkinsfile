pipeline {
    agent { label "dev-server"}

    environment {
        webAppName = "Dockerserver"
        webAppResourceGroup = "Rg-Amit"
        dockerImage = "react_django_demo_app:latest"
        registryCredential = "dockerHub"
        registryName = "samit905787"
    }
    
    stages {
        
        stage("code"){
            steps{
                git url: "https://github.com/samit905787/react_django_demo_app.git", branch: "main"
                echo 'bhaiyya code clone ho gaya'
            }
        }
        stage("build and test"){
            steps{
                sh "docker build -t react_django_demo_app ."
                echo 'code build bhi ho gaya'
            }
        }
        stage("scan image"){
            steps{
                echo 'image scanning ho gayi'
            }
        }
        stage("push"){
            steps{
                withCredentials([usernameColonPassword(credentialsId: 'DOCKER_REGISTRY_CREDS', variable: 'dockerHub'), string(credentialsId: 'dockerhubpass', variable: 'dockerHubPass'), string(credentialsId: 'dockerHubUser', variable: 'dockerHubUser')]) {
                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                sh "docker tag react_django_demo_app:latest ${env.dockerHubUser}/react_django_demo_app:latest"
                sh "docker push ${env.dockerHubUser}/react_django_demo_app:latest"
                echo 'image push ho gaya'
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
                /usr/local/bin/az  webapp config container set --name Dockerserver --resource-group Rg-Amit  --docker-custom-image-name=samit905787/react_django_demo_app:latest
                """
            }
        }
    }

    }
}
