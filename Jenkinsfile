pipeline {
    agent any
    triggers {
    pollSCM('') // Enabling being build on Push
   }  
    environment {
        image_name="428650911713.dkr.ecr.us-east-1.amazonaws.com/flask-project"
    }
    stages {
        stage('Build') {
            steps {
              sh '''
                docker build -t "${image_name}:$GIT_COMMIT" /flaskapp/
              '''
            }
        }
        stage('Push') {
            steps {
               sh '''
                  docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 428650911713.dkr.ecr.us-east-1.amazonaws.com
                  docker push ${image_name}:$GIT_COMMIT
                '''
            }
        }
        stage("Deploy") {
            steps {
                sh '''
                    helm upgrade flaskrelease pragmatic-flask/helmchart/ --install --atomic --wait
                '''
          }
        }
       }
    }
