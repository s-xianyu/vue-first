pipeline {
    agent {
        docker {
            image 'node:12-slim'
            args '-p 8989:8080'
        }
    }
    //environment {
    //    CI = 'true'
    //}
    stages {
        stage('Build') {
            steps {
                sh 'npm install --registry https://registry.npm.taobao.org'
            }
        }
        stage('Deliver for uat') {
            when {
                branch 'uat' 
            }
            steps {
                sh './jenkins/scripts/deliver-for-development.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh './jenkins/scripts/kill.sh'
            }
        }
        stage('Deploy for develop') {
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
