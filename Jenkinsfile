pipeline {
  agent any
  //triggers {
  //    pollSCM('* * * * *')
  //}
  // 每个步骤打出时间戳
  //options {
  //      timestamps()
  //}
  environment {
    appname=$(jq -r '.name' package.json)
  }
  stages {
    stage('Test') {
      steps {
        echo "who build:${CAUSE}"
        echo "project name:${PROJECT_NAME}"
        echo "project name2:${JOB_NAME}"
        echo "status:${BUILD_STATUS}"
        echo "custom name:${appname}"
        // echo "custom name1:${appname1}"
      }
    }
    stage('Build') {
      steps {
        sh 'docker build -t 905798597445.dkr.ecr.ap-southeast-1.amazonaws.com/vue-first:${GIT_COMMIT} .'
      }
    }
    stage('Push') {
      steps {
        sh 'docker push 905798597445.dkr.ecr.ap-southeast-1.amazonaws.com/vue-first:${GIT_COMMIT}'
      }
    }
    stage('Clone k8s-yaml') {
      steps {
        sh "git clone ssh://git@git.wokoworks.com:2222/Devops/k8s-yaml.git"
      }
    }
    stage('Update Yaml') {
      steps {
        sh 'sed -i "s/vue-first:.*$/vue-first:${GIT_COMMIT}/" k8s-yaml/front/vue-first.yaml'
        sh 'cd k8s-yaml && git add . && git commit -m  "Update vue-first image version to ${GIT_COMMIT}" && git push origin master'
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