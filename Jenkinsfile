pipeline{
    agent{
        label 'AGENT-1'
    }
    environment{
        appVersion = ''
    }
    parameters{
        booleanParam(name: 'deploy', defaultValue: false, description: 'Toggle this value to Deploy')
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
        stage('Trigger CD'){
              when{
                expression { params.deploy }
              }
             steps {
                script {
                    build job: 'catalogue-cd',
                    parameters: [
                        string(name: 'appVersion', value: "${appVersion}"),
                        string(name: 'deploy_to', value: 'dev')
                    ],
                    propagate: false,  // even SG fails VPC will not be effected
                    wait: false // VPC will not wait for SG pipeline completion
                }
            }
        } 
          
    }
}
 


