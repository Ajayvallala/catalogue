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
    stages{
        stage('Read Package.json'){
            steps{
                script{
                    def packageJSON = readJSON file: 'package.json'
                    appVersion = packageJSON.version
                    echo "appVersion:${appVersion}"
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
        stage('Unit Testing '){
            steps{
                script{
                    sh """
                    echo "Unit testing started"
                    """
                }
            }
        }
        stage('sonar-scan'){
            environment {
                ScannerHome = tool 'sonar-scanner'
            }
            steps{
                script{
                    withSonarQubeEnv(installationName: 'sonar-server'){
                        sh "${ScannerHome}/bin/sonar-scanner"
                    }

                }
            }
        }

        stage('Quality Gates'){
            steps{
                timeout(time: 1, unit: 'HOURS'){
                    waitForQualityGate abortPipeline: true
                }          
            }
        }

        stage('Check Dependabot Alerts') {
            environment { 
                GITHUB_TOKEN = credentials('git-token')
            }
            steps {
                script {
                    // Fetch alerts from GitHub
                    def response = sh(
                        script: """
                            curl -s -H "Accept: application/vnd.github+json" \
                                 -H "Authorization: token ${GITHUB_TOKEN}" \
                                 https://api.github.com/repos/Ajayvallala/catalogue/dependabot alerts
                        """,
                        returnStdout: true
                    ).trim()

                    // Parse JSON
                    def json = readJSON text: response

                    // Filter alerts by severity
                    def criticalOrHigh = json.findAll { alert ->
                        def severity = alert?.security_advisory?.severity?.toLowerCase()
                        def state = alert?.state?.toLowerCase()
                        return (state == "open" && (severity == "critical" || severity == "high"))
                    }

                    if (criticalOrHigh.size() > 0) {
                        error "❌ Found ${criticalOrHigh.size()} HIGH/CRITICAL Dependabot alerts. Failing pipeline!"
                    } else {
                        echo "✅ No HIGH/CRITICAL Dependabot alerts found."
                    }
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


    post {
        always{
            deleteDir()
        }
        success{
            echo "Build has been success"
        }
        failure{
            error "Build has been failed"
        }
    }

}