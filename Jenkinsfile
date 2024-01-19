pipeline {
    agent { label "dev-server"}
    
    stages {
        
        stage("code"){
            steps{
                git url: "https://github.com/samit905787/react_django_demo_app.git", branch: "main"
                echo 'bhaiyya code clone ho gaya'
            }
        }
        stage("build and test"){
            steps{
                // Get the short commit hash
                def commitHash = sh(script: 'git rev-parse --short HEAD', returnStdout: true).trim()
                
                // Build Docker image with version tag
                sh "docker build -t react_django_demo_app:${commitHash} ."
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
                    sh "docker tag react_django_demo_app:${commitHash} ${env.dockerHubUser}/react_django_demo_app:${commitHash}"
                    sh "docker push ${env.dockerHubUser}/react_django_demo_app:${commitHash}"
                    echo 'image push ho gaya'
                }
            }
        }
        stage("deploy"){
            steps{
                // Deploy using the specific version
                sh "docker-compose down && docker-compose up -d"
                echo 'deployment ho gayi'
            }
        }
    }
}
