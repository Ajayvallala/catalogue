pipeline {
    agent {
        label 'AGENT-1'
    }
    environment {
        appVersion=''
        COMPONENT="catalogue"
        AWS_ACCOUNT_ID = "448049818055"
        PROJECT="roboshop"
        REGION="us-east-1"
    }
    options{
        disableConcurrentBuilds()
        timeout(time:10,unit:'MINUTES')
    }
    stages{
        stage('Read Package.json'){
            steps{
                script{
                    def packageJson= readJSON file: 'package.json'
                    appVersion = packageJSON.version
                    echo "appVersion id ${appVersion}"
                }
            }
        }
        stage('Install Dependencies'){
            steps{
                script{
                    sh """
                    npm install
                    """
                }
            }
        }
        stage('Docker Image Build'){
                 steps{
                    script{
                     withAWS(credentials:'aws-creds', region: 'us-east-1'){
                        sh """
                        aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com

                        docker build -t ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .

                        docker push ${AWS_ACCOUNT_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
                        """
                   }
                }
            }
        }
    }
}