@Library('jenkins-shared-library') _

def configmap = [
    project: 'roboshop',
    component: 'catalogue'
]
if(! env.BRANCH_NAME.equalsIgnoreCase('main')){
 nodejsEKSpipeline(configmap)
}
else{
 echo "Please Proceed with Prod Process"
}
