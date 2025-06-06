pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "bhavani1206/case1"
        SCANNER_HOME = tool 'sonar-scanner-latest'
    }

    tools {
        maven 'maven'
    }

    triggers {
        pollSCM('* * * * *')
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: "${BRANCH_NAME}", url: 'https://github.com/bhavanigowda987/Case1_Repo'
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Test & Coverage') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'mvn test'
                    }
                }
                stage('SonarQube Analysis') {
                    steps {
                        withSonarQubeEnv('sonar-server') {
                            sh '''
                            ${SCANNER_HOME}/bin/sonar-scanner \
                            -Dsonar.projectKey=case1 \
                            -Dsonar.sources=src \
                            -Dsonar.java.binaries=target
                            '''
                        }
                    }
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    def qg = waitForQualityGate()
                    if (qg.status != 'OK') {
                        error "Quality Gate failed: ${qg.status}"
                    }
                }
            }
        }

        stage('Docker Build & Scan') {
            steps {
                sh "docker build -t ${DOCKER_IMAGE}:${BRANCH_NAME} ."
                sh "trivy image --exit-code 1 --severity CRITICAL ${DOCKER_IMAGE}:${BRANCH_NAME}"
            }
        }

        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry('', 'DOCKERHUB_CREDENTIALS') {
                        sh "docker push ${DOCKER_IMAGE}:${BRANCH_NAME}"
                    }
                }
            }
        }

        stage('Deploy to Dev') {
            when { branch 'dev' }
            steps {
                sh 'kubectl apply -f k8s/dev-deployment.yaml'
            }
        }

        stage('Deploy to QA') {
            when { branch 'qa' }
            steps {
                sh 'kubectl apply -f k8s/qa-deployment.yaml'
            }
        }

        stage('Approval for Prod') {
            when { branch 'main' }
            steps {
                input message: "Deploy to Production?"
            }
        }

        stage('Deploy to Prod') {
            when { branch 'main' }
            steps {
                sh 'kubectl apply -f k8s/prod-deployment.yaml'
            }
        }
    }

    post {
        failure {
            mail to: 'devops-team@example.com',
                 subject: "Pipeline Failed: ${env.JOB_NAME}",
                 body: "Pipeline ${env.BUILD_URL} failed. Please check the logs."
        }
    }
}
