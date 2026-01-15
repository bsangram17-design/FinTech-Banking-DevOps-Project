pipeline {
  agent any

  environment {
    DOCKER_IMAGE = "fintech-api"
  }

  stages {

    stage('Checkout Code') {
      steps {
        git branch: 'main', url: 'https://github.com/bsangram17-design/FinTech-Banking-DevOps-Project.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        
        sh 'docker build -t fintech-api app/'
      }
    }

    stage('Docker Login') {
      steps {
        withCredentials([usernamePassword(
          credentialsId: 'dockerhub-creds',
          usernameVariable: 'DOCKER_USER',
          passwordVariable: 'DOCKER_PASS'
        )]) {
          sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
        }
      }
    }

    stage('Push Image') {
      steps {
        sh '''
           docker tag fintech-api bsan17/fintech-api:latest

          docker push bsan17/fintech-api:latest
        '''
      }
    }

    stage('Deploy (Blue-Green)') {
      steps {
        sh 'bash scripts/blue-green.sh'
      }
    }
  }

  post {
    success {
      echo 'Deployment completed successfully'
    }
    failure {
      echo 'Deployment failed – rollback required'
    }
  }
}
