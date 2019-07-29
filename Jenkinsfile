pipeline {
  agent any
  //triggers {
  //    pollSCM('* * * * *')
  //}
  // 每个步骤打出时间戳
  options {
    timeout(time: 1, unit: 'HOURS')
  //      timestamps()
  }
  environment {
    registry = "905798597445.dkr.ecr.ap-southeast-1.amazonaws.com"
    appname = sh(returnStdout: true, script: "jq -r '.name' package.json").trim()
  }
  stages {
    stage('Test') {
      steps {
        echo "project name:${appname}"
        echo "registry:${registry}"
      }
    }
    stage('Build') {
      steps {
        input message: 'Finished using the web site? (Click "Proceed" to continue)'
        sh 'docker build -t 905798597445.dkr.ecr.ap-southeast-1.amazonaws.com/${appname}:${GIT_COMMIT} .'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push 905798597445.dkr.ecr.ap-southeast-1.amazonaws.com/${appname}:${GIT_COMMIT}'
      }
    }
    stage('Clone k8s-yaml') {
      steps {
        sh "git clone ssh://git@git.wokoworks.com:2222/Devops/k8s-yaml.git"
      }
    }
    stage('Update Yaml') {
      steps {
        sh 'sed -i "s/${appname}:.*$/${appname}:${GIT_COMMIT}/" k8s-yaml/front/${appname}.yaml'
        sh 'cd k8s-yaml && git add . && git commit -m  "Update ${appname} image version to ${GIT_COMMIT}" && git push origin master'
      }
    }
    stage('CleanWS') {
      steps {
        script {
          try {
            deleteDir()
          }catch(err){
            echo "${err}"
            sh 'exit 1'
          }
        }
      }
    }
  }
}