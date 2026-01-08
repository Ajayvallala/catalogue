pipeline {
    agent {
        label 'AGENT-1'
    }

    environment {
        appVersion=''
    }
    stages {
        stage('read package.json') {
            steps {
                script {
                    def packageJson = readJSON file: 'package.json'
                    appVersion = packageJson.version
                    echo "appVersion is $appVersion"
                }
                
            }
        }

        stage('install dependencies'){
            steps{
                script{
                    sh """
                    npm install
                    """
                }
            }
        }

        stage('Docker Build'){
            steps{
                script{
                    withAWS(credentials:'aws-creds', region:'us-east-1'){
                        sh """
                        aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 448049818055.dkr.ecr.us-east-1.amazonaws.com
                        docker build -t 448049818055.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:$appVersion .
                        docker push 448049818055.dkr.ecr.us-east-1.amazonaws.com/roboshop/catalogue:$appVersion
                        """
                    }
                }
            }
        }
    }
}