pipeline {
    agent {
        docker {
            image 'node:6-alpine'
            args '-p 3100:3000 -p 5100:5000'
        }
    }
    environment {
        CI = 'true'
    }
    stages {
        stage('Build') {
            steps {
                sh 'npm install --registry https://registry.npm.taobao.org'
            }
        }
        stage('Deliver for development') {
            when {
                branch 'uat' 
            }
            steps {
                sh './jenkins/scripts/deliver-for-development.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
        stage('Deploy for production') {
            when {
                branch 'develop'  
            }
            steps {
                sh 'npm run dev'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}
