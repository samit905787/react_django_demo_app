pipeline {
    agent { label "dev-server" }

    environment {
        webAppName = "Dockerserver"
        webAppResourceGroup = "Rg-Amit"
        dockerImage = "react_django_demo_app"
        registryCredential = "DOCKER_CREDS"
        registryName = "samit905787"
    }

    stages {
        stage("code") {
            steps {
                git url: "https://github.com/samit905787/react_django_demo_app.git", branch: "main"
                echo 'Code clone successful'
            }
        }

        stage("build and test") {
            steps {
                sh "docker build -t react_django_demo_app ."
                echo 'Code build successful'
            }
        }

        stage("scan image") {
            steps {
                echo 'Image scanning completed'
                // Add your image scanning steps here if needed
            }
        }

        stage("push") {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.registryCredential, variable: 'DOCKER_CREDS')]) {
                        sh "docker login -u \${DOCKER_CREDS_USR} -p \${DOCKER_CREDS_PSW}"
                        sh "docker tag ${env.dockerImage} ${env.registryName}/${env.dockerImage}"
                        sh "docker push ${env.registryName}/${env.dockerImage}"
                        echo 'Image push successful'
                    }
                }
            }
        }

        stage('deploy to appservice') {
            steps {
                script {
                    withCredentials([
                        string(credentialsId: 'app-id-1', variable: 'username'),
                        string(credentialsId: 'tenant-id-1', variable: 'tenant'),
                        string(credentialsId: 'app-id-pass-1', variable: 'password')
                    ]) {
                        sh """
                            /usr/local/bin/az login --service-principal -u \${username} -p \${password} --tenant \${tenant}
                            /usr/local/bin/az webapp config container set --name \${env.webAppName} --resource-group \${env.webAppResourceGroup} --docker-custom-image-name=\${env.registryName}/\${env.dockerImage}
                        """
                    }
                }
            }
        }
    }
}
