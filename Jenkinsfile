/* pipeline{
    agent{
        label 'AGENT-1'
    }
    environment{
        appVersion = ''
    }

    stages{
        stage('Read package.json'){
            steps{
                script {
                    def packageJSON = readJSON file: 'package.json'
                    appVersion = packageJSON.version
                    echo "appVersion:${appVersion}"
                }
            }
        }
        stage('Install Dependencies'){
            steps {
                script {
                    sh """
                    npm install
                    """
                }
            }
        }
        stage('Docker Build'){
            steps{
                script{
                    withAWS(credentials: 'aws-creds', region: 'us-east-1'){
                    sh """
                       aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 448049818055.dkr.ecr.us-east-1.amazonaws.com

                       docker build -t 448049818055.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:${appVersion} .

                       docker push 448049818055.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:${appVersion}
                    """    
                }
                }
            }
        }
          
    }
}
 */


pipeline {
    agent {
        label 'AGENT-1'
    }
    environment{
        appVersion = ''
    }

    stages{
        stage('Read Package.Json'){
            steps {
                script{
                   def packageJSON = readJSON file: 'package.json'
                   appVersion = packageJSON.version
                   echo "App Version is ${appVersion}"

                }
            }
        }
    }
}