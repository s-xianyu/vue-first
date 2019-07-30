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
    K8S_YAML_GIT_URL = 'ssh://git@git.wokoworks.com:2222/Devops/k8s-yaml.git'
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
      steps {
        script {
          try {
            timeout(time:30, unit:'SECONDS') {
              //userInput = input(
              //  message: 'Input info',
              //  parameters: [
              //    [$class: 'TextParameterDefinition',
              //     defaultValue: 'push',
              //     description: 'push image', name: 'enter push'
              //    ]
              //  ]
              //)
              //echo "123"
              input message: "this action will stop service, are you sure you want to execute？", ok: "push"
            }
          } catch(err) { // timeout reached or input Aborted
              echo "${err}"
              //def user = err.getCauses()[0].getUser()
              //  if('SYSTEM' == user.toString()) {
              //    echo ("Input timeout expired")
              //  } else {
              //      echo "Input aborted by: [${user}]"
              //  }
              sh 'exit 1'
            }
        }
        sh "docker push ${registry}/${appname}:${GIT_COMMIT}"
      }
    }
    stage('Clone k8s-yaml') {
      steps {
        echo "Checkout will be done for Git branch: master"
        // checkout([$class: 'GitSCM', branches: [[name: "*/master"]], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: ${K8S_YAML_GIT_URL}]]])
        checkout([$class: 'GitSCM', branches: [[name: 'origin/master']], userRemoteConfigs: [[url: "${K8S_YAML_GIT_URL}",credentialsId:'linjiale-gogs']])
        // sh "git clone ssh://git@git.wokoworks.com:2222/Devops/k8s-yaml.git"
      }
    }
    stage('Update Yaml') {
      steps {
        sh 'sed -i "s/${appname}:.*$/${appname}:${GIT_COMMIT}/" k8s-yaml/front/${appname}.yaml'
        sh 'cd k8s-yaml && git add . && git commit -m  "Update ${appname} image version to ${GIT_COMMIT}" && git push origin master'
      }
    }
    //stage('CleanWS') {
    //  steps {
    //    script {
    //      try {
    //        deleteDir()
    //      }catch(err){
    //        echo "${err}"
    //        sh 'exit 1'
    //      }
    //    }
    //  }
    //}
    //stage('CleanWorkspace') {
    //  steps {
    //    echo "clean k8s-yaml list"
    //    // cleanWs(patterns: [[pattern: './k8s-yaml', type: 'INCLUDE']])
    //  }
    //}
  }
  post {
    success {
      dingTalk accessToken: 'https://oapi.dingtalk.com/robot/send?access_token=91d8100e91315c3940146c26597efe344eb23e5cfac31699848b0c68d264fe65', imageUrl:'', jenkinsUrl:'',
      message:"构建完成，干得不错!"
      echo "failure"
    }
    failure {
      dingTalk accessToken: 'https://oapi.dingtalk.com/robot/send?access_token=91d8100e91315c3940146c26597efe344eb23e5cfac31699848b0c68d264fe65', imageUrl:'', jenkinsUrl:'',
      message:"发布失败，干得不错!"
      echo "failure"
    }
    cleanup {
      echo 'One way or another, I have finished'
      dir("${workspace}/k8s-yaml") {
        deleteDir()
      } 
    }
  }
}