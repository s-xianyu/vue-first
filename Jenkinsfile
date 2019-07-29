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
        input message: 'one (Click "Proceed" to continue)'
        sh "docker build -t ${registry}/${appname}:${GIT_COMMIT} ."
      }
    }
    stage('Push') {
      options {
        timeout(time: 60, unit: 'SECONDS') {
          input message: "this action will stop service, are you sure you want to execute？", ok: "yes"
        }
      }
      steps {
        // input message: 'two (Click "Proceed" to continue)'
        sh "docker push ${registry}/${appname}:${GIT_COMMIT}"
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