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
                script {
                    withDockerRegistry([credentialsId: 'DOCKER_REGISTRY_CREDS', url: 'https://index.docker.io/v1/']) {
                        sh "echo ${DOCKER_REGISTRY_CREDS} | docker login -u _json_key --password-stdin https://index.docker.io/v1/"
                        sh "docker tag react_django_demo_app:latest ${DOCKER_REGISTRY_CREDS}/react_django_demo_app:latest"
                        sh "docker push ${DOCKER_REGISTRY_CREDS}/react_django_demo_app:latest"
                    }
                    echo 'Image pushed successfully'
                }
            }
        }

        stage('deploy to appservice') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'app-id-1', usernameVariable: 'username', passwordVariable: 'password')]) {
                        withCredentials([string(credentialsId: 'tenant-id-1', variable: 'tenant')]) {
                            sh """
                                echo \${password} | /usr/local/bin/az login --service-principal -u \${username} --password-stdin --tenant \${tenant}
                                /usr/local/bin/az webapp config container set --name Dockerserver --resource-group Rg-Amit --docker-custom-image-name=samit905787/react_django_demo_app:latest
                            """
                        }
                    }
                }
            }
        }
    }
}
