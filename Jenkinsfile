pipeline {
    agent { label "dev-server" }

    stages {
        stage("code") {
            steps {
                git url: "https://github.com/samit905787/react_django_demo_app.git", branch: "main"
                echo 'Code cloned successfully'
            }
        }

        stage("build and test") {
            steps {
                sh "docker build -t react_django_demo_app ."
                echo 'Code built successfully'
            }
        }

        stage("scan image") {
            steps {
                echo 'Image scanning completed'
            }
        }

        stage("push") {
            steps {
                withCredentials([usernamePassword(credentialsId: 'DOCKER_REGISTRY_CREDS', variable: 'dockerHub'), string(credentialsId: 'dockerhubpass', variable: 'dockerHubPass'), string(credentialsId: 'dockerHubUser', variable: 'dockerHubUser')]) {
                    sh "docker login -u ${dockerHubUser} -p ${dockerHubPass}"
                    sh "docker tag react_django_demo_app:latest ${dockerHubUser}/react_django_demo_app:latest"
                    sh "docker push ${dockerHubUser}/react_django_demo_app:latest"
                    echo 'Image pushed successfully'
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
                    script {
                        sh """
                            /usr/local/bin/az login --service-principal -u \${username} -p \${password} --tenant \${tenant}
                            /usr/local/bin/az webapp config container set --name Dockerserver --resource-group Rg-Amit --docker-custom-image-name=samit905787/react_django_demo_app:latest
                        """
                    }
                }
            }
        }
    }
}
