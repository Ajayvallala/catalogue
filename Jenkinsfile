pipeline{
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
    }
}
