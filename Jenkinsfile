pipeline{
    agent{
        label 'AGENT-1'
    }
    environment{
        appVersion = ''
    }
    parameters{
        booleanParam(name: 'Deploy', defaultValue: false, description: 'Toggle this value to Deploy')
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
             when {
                expression { 
                    params.Deploy == true 
                }
            }
            steps{
                 build job: 'catalogue-cd'
                 parameters: [
                              string(name: 'Imageversion', value: "${appVarsion}"),
                              string(name: 'Deploy', value: 'dev') // Example: passing an upstream parameter
                          ],
                 wait: false
                 propagate: false
            }
        }
          
    }
}
 


