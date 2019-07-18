pipeline {
    agent {
        docker {
            image 'node:6-alpine'
            args '-p 8989:8080'
        }
    }
    environment {
        CI = 'true'
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm install --registry=https://registry.npm.taobao.org'
            }
        }
        stage('Deliver for uat') {
            when {
                branch 'uat' 
            }
            steps {
                sh './jenkins/scripts/deliver-for-uat.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
        stage('Deploy for dev') {
            when {
                branch 'develop'  
            }
            steps {
                sh './jenkins/scripts/deploy-for-develop.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
        stage('Deploy for master') {
            when {
                branch 'master'  
            }
            steps {
                sh './jenkins/scripts/deploy-for-develop.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}