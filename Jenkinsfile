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
                sh 'npm install --registry https://registry.npm.taobao.org' 
            }
        }
        stage('Test') {
            steps {
                sh 'npm run unit'
            }
        }
        stage('Deliver for develop') {
            when {
                branch 'develop' 
            }
            steps {
                sh 'npm run dev'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
        stage('Deploy for production') {
            when {
                branch 'production'  
            }
            steps {
                sh './jenkins/scripts/deploy-for-production.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
    }
}
