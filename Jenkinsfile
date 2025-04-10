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

        stage('Authenticate Salesforce Org') {
            steps {
                 withCredentials([file(credentialsId:'2579a42d-3efe-45a9-aeb2-7e07583c28ce', variable: 'jwt_key_file')]) {
                 sh 'sf org login jwt --client-id 3MVG9rZjd7MXFdLgA4ym8bhSwiFNIHiSqo_uLz66HyBrAfHWef6G4fDcd9RPeanyEsRxsKDwtvObwzNMloBA1 --username rajkumar.gaikwad3@gmail.com --jwt-key-file ${jwt_key_file} --alias my-hub-org --set-default --set-default-dev-hub'
                }
            }
        }

         stage('Run Salesforce Code Scanner') {
            steps {
                // Run the Salesforce CLI Code Scanner
                 sh 'sf scanner run --target "**/default/**" > scanner-results.csv'
            }
        }


        /* stage('Run Salesforce Code Analyzer') {
            steps {
                // Run the Salesforce CLI code analyzer
                sh 'sf code-analyzer run --workspace ./force-app/**/*.cls --rule-selector all > analyzer-results.csv'
            }
        }*/

        stage('Archive Results') {
            steps {
                // Archive the analysis results
                archiveArtifacts artifacts: '*.csv', fingerprint: true
            }
        }

    
}
}
