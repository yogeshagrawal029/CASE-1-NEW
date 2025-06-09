pipeline {
  agent any
  environment {
    IMAGE_NAME = "bhavani1206/first"
    MANIFEST_PATH = "manifest_file/k8s"
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', url: 'https://github.com/bhavanigowda987/Case1_Repo'
      }
    }

    stage('Build and Test') {
      steps {
        sh 'ls -ltr'
        sh 'mvn clean package'
      }
    }

    stage('Build and Push Docker Image') {
      steps {
        script {
          sh "docker build -t ${IMAGE_NAME} ."
        }
      }
    }

    stage('Push to DockerHub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'DOCKERHUB_CREDENTAILS', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker push $IMAGE_NAME
          '''
        }
      }
    }

    stage('Static
