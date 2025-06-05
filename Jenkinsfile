pipeline{
    agent any
    tools{
        maven 'maven' 
    }
    //environment {
        //SCANNER_HOME=tool 'sonar-scanner'
    //}
    stages {
        stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('Checkout From Git'){
            steps{
                git branch: 'main', url: 'https://github.com/bhavanigowda987/Case1_Repo'
            }
        }
        stage('mvn install'){
            steps{
                sh 'mvn clean install'
            }
        }
        //stage("Sonarqube Analysis "){
            //steps{
                //withSonarQubeEnv('sonar-server') {
                    //sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Petclinic \
                    //-Dsonar.java.binaries=. \
                    //-Dsonar.projectKey=Petclinic '''
               // }
            //}
       // }
        //stage("quality gate"){
           //steps {
                 //script {
                     //waitForQualityGate abortPipeline: false, credentialsId: 'Sonar-token' 
                    //}
                //} 
        //} 
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'DOCKERHUB_CREDENTIALS', toolName: 'docker'){   
                       sh "docker build -t bhavani1206/imagetest ."
                       sh "docker push bhavani1206/imagetest "
                    }
                }
            }
        }
        #stage("TRIVY"){
            #steps{
                #sh "trivy image bhavani1206/imagetest > trivy.txt" 
           # }
       # }
        stage('Clean up containers') {   //if container runs it will stop and remove this block
          steps {
           script {
             try {
                sh 'docker stop pet1'
                sh 'docker rm pet1'
                } catch (Exception e) {
                  echo "Container pet1 not found, moving to next stage"  
                }
            }
          }
        }
        stage ('Manual Approval'){
          steps {
           script {
             timeout(time: 10, unit: 'MINUTES') {
              def approvalMailContent = """
              Project: ${env.JOB_NAME}
              Build Number: ${env.BUILD_NUMBER}
              Go to build URL and approve the deployment request.
              URL de build: ${env.BUILD_URL}
              """
             mail(
             to: 'postbox.aj99@gmail.com',
             subject: "${currentBuild.result} CI: Project name -> ${env.JOB_NAME}", 
             body: approvalMailContent,
             mimeType: 'text/plain'
             )
            input(
            id: "DeployGate",
            message: "Deploy ${params.project_name}?",
            submitter: "approver",
            parameters: [choice(name: 'action', choices: ['Deploy'], description: 'Approve deployment')]
            )  
          }
         }
       }
    }
        stage('Deploy to conatiner'){
            steps{
                sh 'docker run -d --name java1 -p 8082:8080 bhavani1206/imagetest'
            }
        }
        stage('Deploy to kubernets'){
            steps{
                script{
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                       sh 'kubectl apply -f deployment.yaml'
                  }
                }
            }
        }
    }
    post {
     always {
        emailext attachLog: true,
            subject: "'${currentBuild.result}'",
            body: "Project: ${env.JOB_NAME}<br/>" +
                "Build Number: ${env.BUILD_NUMBER}<br/>" +
                "URL: ${env.BUILD_URL}<br/>",
            to: 'postbox.aj99@gmail.com',
            attachmentsPattern: 'trivy.txt'
        }
    }
}


// try this approval stage also 

stage('Manual Approval') {
  timeout(time: 10, unit: 'MINUTES') {
    mail to: 'postbox.aj99@gmail.com',
         subject: "${currentBuild.result} CI: ${env.JOB_NAME}",
         body: "Project: ${env.JOB_NAME}\nBuild Number: ${env.BUILD_NUMBER}\nGo to ${env.BUILD_URL} and approve deployment"
    input message: "Deploy ${params.project_name}?", 
           id: "DeployGate", 
           submitter: "approver", 
           parameters: [choice(name: 'action', choices: ['Deploy'], description: 'Approve deployment')]
  }
}
