pipeline {
    agent any
    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.PATH}"
    }
    stages {
        stage('Check SFDX') {
            steps {
                sh 'which sfdx'
                sh 'sfdx --version'
            }
        }
    }
}
