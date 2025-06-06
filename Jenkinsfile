pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner-latest'

    }

    stages {
        stage('clean workspace') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout From Git') {
            steps {
                git branch: 'main', url: 'https://github.com/bhavanigowda987/Case1_Repo'
            }
        }

        stage('mvn compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('mvn test') {
            steps {
                sh 'mvn test'
            }
        }

        stage("Sonarqube Analysis "){
            steps{
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=case1 \
                    -Dsonar.java.binaries=. \
                    -Dsonar.projectKey=case1 '''
                }
            }
        }
        stage("quality gate"){
           steps {
                 script {
                     waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token' 
                    }
                } 
        } 
    } // closes stages
    stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'DOCKERHUB_CREDENTIALS', toolName: 'docker'){   
                       sh "docker build -t case1 ."
                       sh "docker tag case1 bhavani1206/case1:latest "
                       sh "docker push bhavani1206/case1:latest "
                    }
                }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image bhavani1206/case1:latest > trivy.txt" 
            }
        }
    tage('Deploy to conatiner'){
            steps{
                sh 'docker run -d --name case1 -p 8082:8080 bhavani1206/case1:latest'
            }
        }
} // closes pipeline
