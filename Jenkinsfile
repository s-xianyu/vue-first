pipeline {
  agent any
  stages {
    stage('Deliver for uat') {
      when {
        branch 'uat'
      }
      steps {
        sh 'docker build -t vue-first:${GIT_COMMIT} .'
      }
    }
    stage('Deploy for dev') {
      when {
        branch 'develop'
      }
      steps {
        sh '''
        docker build -t 905798597445.dkr.ecr.ap-southeast-1.amazonaws.com/vue-first:${GIT_COMMIT} .
        docker push 905798597445.dkr.ecr.ap-southeast-1.amazonaws.com/vue-first:${GIT_COMMIT}
        '''
      }
    }
    stage('Deploy for master') {
      when {
        branch 'master'
      }
      steps {
        sh './jenkins/scripts/deploy-for-develop.sh'
        input 'Finished using the web site? (Click "Proceed" to continue)'
        sh './jenkins/scripts/kill.sh'
      }
    }
  }
}