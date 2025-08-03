pipeline {
    agent any

    tools {
        jdk 'java 21'
        maven 'Maven 3' // Match Global Tool Configuration
    }


    stages {
        stage('Checkout from SCM') {
            steps {
                git branch:'main', url: 'https://github.com/marutih8/MT-CASE-1_NEW.git'
            }
        }
    
        stage('Build Application') {
            steps {
                sh 'mvn clean install'
            }
        }
    }
}
