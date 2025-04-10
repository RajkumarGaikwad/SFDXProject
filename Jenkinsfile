pipeline {
    agent any
    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.PATH}"
    }
    stages {

        stage('Checkout Code') {
            steps {
                // Checkout the code from the repository
                checkout scm
            }
        }

        stage('Check SF') {
            steps {
                sh 'which sf'
                sh 'sf --version'
            }
        }

        stage('Authenticate Salesforce Org') {
            steps {
                 withCredentials([file(credentialsId:'2579a42d-3efe-45a9-aeb2-7e07583c28ce', variable: 'jwt_key_file')]) {
                 sh 'sf org login jwt --client-id 3MVG9rZjd7MXFdLgA4ym8bhSwiFNIHiSqo_uLz66HyBrAfHWef6G4fDcd9RPeanyEsRxsKDwtvObwzNMloBA1 --username rajkumar.gaikwad3@gmail.com --jwt-key-file ${jwt_key_file} --alias my-hub-org --set-default-dev-hub'
                }
            }
        }

         stage('Run Salesforce Code Analyzer') {
            steps {
                // Run the Salesforce CLI code analyzer
                sh 'sf project deploy validate'
                sh 'cd SFDXProject'
                sh 'sf scanner run --target "**/default/**" --category Design,Best Practices --csv > analysis-results.csv'
            }
        }

        stage('Archive Results') {
            steps {
                // Archive the analysis results
                archiveArtifacts artifacts: 'analysis-results.csv', fingerprint: true
            }
        }

    
}
}
