pipeline {
    agent any
    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.PATH}"
    }
    stages {
        
         stage('Setup Salesforce CLI') {
            steps {
                // Install Salesforce CLI (if not already installed)
                sh 'curl -sL https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz | tar -xJ && ./sfdx/install'
            }
        }
        
        stage('Check SFDX') {
            steps {
                sh 'which sfdx'
                sh 'sfdx --version'
            }
        }
    }
}
