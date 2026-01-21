// @Library('jenkins-shared-library') _

// def configmap = [
//     project: "roboshop",
//     component: "catalogue"
// ]
// if(! env.BRANCH_NAME.equalsIgnoreCase('main')){
//  nodejsEKSpipeline(configmap)
// }
// else{
//  echo "Please Proceed with Prod Process"
// }


// @Library('jenkins-shared-library') _
//   def configMap = [
//     project : "roboshop",
//     component : "catalogue"
//   ]
//   if( ! env.BRANCH_NAME.equalsIgnoreCase('main') ){
//     nodejsEKSpipeline(configMap)
//   }
//   else{
//     echo "Please Proceed with Prod Process"
//   }

@library('jenkins-shard-library') _
  def configMap = [
    project : "roboshop",
    component : "catalogue"
  ]

  if( ! env.BRANCH_NAME.equalsIgnoreCase('main')){
    nodejsEKSpipeline(configMap)
  }
  else{
    echo "Please Proceed with prod process"
  }
 