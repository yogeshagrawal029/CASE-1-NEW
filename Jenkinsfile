pipeline {
    agent any

    tools {
        maven 'maven 3' // Match Global Tool Configuration
    }


    stages {
        stage('Checkout from SCM') {
            steps {
                git branch:'main', url: 'https://github.com/yogeshagrawal029/CASE-1-NEW.git'
            }
        }
    
        stage('Build Application') {
            steps {
                sh 'mvn clean install'
            }
        }
    }
}
