pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'docker build -t fintech-api .'
      }
    }
    stage('Push') {
      steps {
        sh 'docker tag fintech-api yourdockerhub/fintech-api'
        sh 'docker push yourdockerhub/fintech-api'
      }
    }
    stage('Deploy') {
      steps {
        sh 'bash scripts/blue-green.sh'
      }
    }
  }
}
