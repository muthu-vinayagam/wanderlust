pipeline {
    agent {
        label 'minikube'  // Runs on an agent labeled 'minikube'
    }

    environment {
        GIT_REPO_URL = 'https://github.com/muthu-vinayagam/wanderlust.git' // Replace with your repository URL
        GIT_BRANCH = 'main' // Replace with your branch name
        GIT_CREDENTIALS_ID = 'git-secret' // Replace with the ID of your Jenkins credentials
        IMAGE_NAME_FRONTEND = 'muthuvinayagam92/frontend'
        IMAGE_NAME_BACKEND = 'muthuvinayagam92/backend'  // Replace with your Docker Hub username and image name
        TAG = 'latest'  // Replace with your desired image tag
        DOCKERFILE_PATH = '/home/ubuntu/workspace/docker/'  // Path to your Dockerfile relative to the Jenkins workspace
        DOCKERHUB_USERNAME = 'muthuvinayagam92' // Replace with your Docker Hub username
        DOCKERHUB_PASSWORD = 'Muthuvinay123456789' // Replace with your Docker Hub password
    }

    stages {
        stage('Clean Workspace') {
            steps {
                echo 'Cleaning the workspace...'
                deleteDir()  // Cleans the workspace
            }
        }
        
        stage('Clone Repository') {
            steps {
                echo 'Cloning the repository...'
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: env.GIT_BRANCH]],
                    doGenerateSubmoduleConfigurations: false,
                    extensions: [],
                    submoduleCfg: [],
                    userRemoteConfigs: [[
                        url: env.GIT_REPO_URL,
                        credentialsId: env.GIT_CREDENTIALS_ID
                    ]]
                ])
            }
        }

        stage('Build Docker Images') {
            parallel {
                stage('Build Backend Docker Image') {
                    steps {
                        dir('backend') {
                            echo 'Building backend Docker image...'
                            script {
                                sh "sudo docker build -t ${IMAGE_NAME_BACKEND}:${TAG} -f ${DOCKERFILE_PATH}backend/Dockerfile ."
                            }
                        }
                    }
                }
                stage('Build Frontend Docker Image') {
                    steps {
                        dir('frontend') {
                            echo 'Building frontend Docker image...'
                            script {
                                sh "sudo docker build -t ${IMAGE_NAME_FRONTEND}:${TAG} -f ${DOCKERFILE_PATH}frontend/Dockerfile ."
                            }
                        }
                    }
                }
            }
        }

        stage('Push Docker Images to Docker Hub') {
            steps {
                echo 'Pushing Docker images to Docker Hub...'
                script {
                    sh '''
                        sudo docker login -u "${DOCKERHUB_USERNAME}" -p "${DOCKERHUB_PASSWORD}" docker.io
                        sudo docker push ${IMAGE_NAME_BACKEND}:${TAG}
                        sudo docker push ${IMAGE_NAME_FRONTEND}:${TAG}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Successfully built and pushed Docker images'
        }
        failure {
            echo 'Failed to build or push Docker images'
        }
    }
}
