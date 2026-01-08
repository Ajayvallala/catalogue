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
                def packageJson = readJSON file: 'package.json'
                appVersion = packageJson.version
                echo "appVersion is $appVersion"
            }
        }
    }
}