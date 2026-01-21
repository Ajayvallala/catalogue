pipeline{
    agent{
        label 'AGENT-1'
    }
    options{
        timeout(time:1, units: 'HOURS')
        disableConcurrentBuilds()
    }
    environment{
        appVersion = ''
        PROJECT= "roboshop"
        COMPONENT= "catalogue"
        AWS_ACCOUNT_ID= "448049818055"
        REGION="us-east-1"
    }

    parameters{
        booleanParam(name: 'deploy', defaultValue: false, description: 'Toggle this value to  deploy to dev environment')
    }

    stages{
        stage('Read Package.json'){
            steps{
                def packageJSON= readJSON file: 'package.json'
                appVersion= packageJSON.version
                echo "appVersion:${appVersion}"
            }
        }

        stage('Install Depenedencies'){
            steps{
                script{
                    sh """
                       npm install
                       """                 
                }
            }
        }

        stage('Run Unit test'){
            steps{
                script{
                    echo "Running Unit test cases"
                }
            }
        }
        stage('sonar scan'){
            environment{
                SonarHome= tool 'sonar-scanner'
            }
            steps{
                script{
                    withSonarQubeEnv(credentials: 'sonar-server'){
                        sh "${SonarHome}/bin/sonar-scanner"
                    }
                   
                }
            }
        }
        stage('Quality Gates'){
            steps{
                timeout(time:1, unit: 'HOURS'){
                    waitForQualityGate abortPipeline:true
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
                                 https://api.github.com/repos/Ajayvallala/catalogue/dependabot/alerts
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
        stage('Check Scan Results') {
                steps {
                    script {
                        withAWS(credentials: 'aws-creds', region: 'us-east-1') {
                        // Fetch scan findings
                            def findings = sh(
                                script: """
                                    aws ecr describe-image-scan-findings \
                                    --repository-name ${PROJECT}/${COMPONENT} \
                                    --image-id imageTag=${appVersion} \
                                    --region ${REGION} \
                                    --output json
                                """,
                                returnStdout: true
                            ).trim()

                            // Parse JSON
                            def json = readJSON text: findings

                            def highCritical = json.imageScanFindings.findings.findAll {
                                it.severity == "HIGH" || it.severity == "CRITICAL"
                            }

                            if (highCritical.size() > 0) {
                                echo "❌ Found ${highCritical.size()} HIGH/CRITICAL vulnerabilities!"
                                currentBuild.result = 'FAILURE'
                                error("Build failed due to vulnerabilities")
                            } else {
                                echo "✅ No HIGH/CRITICAL vulnerabilities found."
                            }
                        }
                    }
                }
            }
        stage('Trigger CD'){
            when{
                expression { params.deploy }
            }
            steps{
                script{
                    build job: "${COMPONENT}-CD",
                    parameters: [
                        string(name: 'appVersion', value: "${appVersion}"),
                        string(name: 'deploy_to', value: 'dev')
                    ],
                    propagate: false,
                    wait: false
                }
            }
        }
    }
    post{
        always{
            deleteDir()
        }
        success{
            echo "Pipeline Success"
        }
        failed{
            error "Pipeline failed"
        }
    }
}