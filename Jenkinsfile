pipeline {
    agent any

    tools {
        maven 'maven'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
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
    } // closes stages
} // closes pipeline
