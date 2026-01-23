pipeline {
  agent any

  environment {
    IMAGE_NAME = "bsan17/fintech-api"
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/bsangram17-design/FinTech-Banking-DevOps-Project.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        sh 'docker build -t fintech-api app/'
      }
    }

    stage('Push Image') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'USER',
          passwordVariable: 'PASS'
        )]) {
          sh '''
            echo $PASS | docker login -u $USER --password-stdin
            docker tag fintech-api $IMAGE_NAME:latest
            docker push $IMAGE_NAME:latest
          '''
        }
      }
    }

    stage('Blue-Green Deploy') {
      steps {
        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
          credentialsId: 'aws-creds']]) {
          sh 'bash scripts/blue-green.sh'
        }
      }
    }
  }
}
