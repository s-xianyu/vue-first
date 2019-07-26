pipeline {
  agent any
  //triggers {
  //    pollSCM('* * * * *')
  //}
  options {
        timestamps()
  }
  stages {
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
    stage('Build') {
      steps {
        echo "current git project: ${GIT_PROJECT}"
        sh 'docker build -t 905798597445.dkr.ecr.ap-southeast-1.amazonaws.com/vue-first:${GIT_COMMIT} .'
      }
    }
    stage('Push') {
      steps {
        echo "current commit: ${GIT_COMMIT}"
        echo "current commit: ${GIT_BRANCH}"
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
  }
}