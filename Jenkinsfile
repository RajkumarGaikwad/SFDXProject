pipeline {
    
    agent any

    
    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.PATH}"
        TARGET_BRANCH = "${env.CHANGE_TARGET}"
        SOURCE_BRANCH= "${env.CHANGE_BRANCH}"
    }
    
    stages {
    
            stage('Authenticate Salesforce Org') {
                when {
                    allOf {
                        expression { return env.CHANGE_ID != null } // Confirms it's a PR
                        expression { return env.CHANGE_TARGET == 'master' } // PR target is master
                    }
                }
                steps {
                     withCredentials([file(credentialsId:'2579a42d-3efe-45a9-aeb2-7e07583c28ce', variable: 'jwt_key_file')]) {
                     sh 'sf org login jwt --client-id 3MVG9rZjd7MXFdLgA4ym8bhSwiFNIHiSqo_uLz66HyBrAfHWef6G4fDcd9RPeanyEsRxsKDwtvObwzNMloBA1 --username rajkumar.gaikwad3@gmail.com --jwt-key-file ${jwt_key_file} --alias my-hub-org --set-default --set-default-dev-hub'
                    }
                }
            }

        stage('Generate Delta') {
         when {
                allOf {
                    expression { return env.CHANGE_ID != null } // Confirms it's a PR
                    expression { return env.CHANGE_TARGET == 'master' } // PR target is master
                }
            }
            steps {
                script {
                    sh '''
                        echo "Generating delta between commits..."
                        
                        git fetch origin $TARGET_BRANCH:refs/remotes/origin/$TARGET_BRANCH 

                        git checkout origin/$TARGET_BRANCH
                        
                        git fetch origin $SOURCE_BRANCH:$SOURCE_BRANCH

                        git checkout $SOURCE_BRANCH
                        
                        git diff --name-only origin/$TARGET_BRANCH $SOURCE_BRANCH -- ./force-app  > delta-files.txt
                        
                    '''
                }
            }
        }

        stage('Run Salesforce Code Analyzer') {
            when {
                allOf {
                    expression { return env.CHANGE_ID != null } // Confirms it's a PR
                    expression { return env.CHANGE_TARGET == 'master' } // PR target is master
                }
            }
            steps {
                script {
                    sh '''
                        if [ -s delta-files.txt ]; then
                            echo "Running SF Code Analyzer  on delta files..."
                            sf code-analyzer run --workspace $(cat delta-files.txt | tr '\\n' ',' | sed 's/,$//') --rule-selector all --view detail --output-file "code-analyzer-results.html" --config-file "code-analyzer.yml"
                        else
                            echo "No delta files to scan."
                        fi
                    '''
                }
            }
        }
    

            stage('Archive Results') {
                when {
                allOf {
                    expression { return env.CHANGE_ID != null } // Confirms it's a PR
                    expression { return env.CHANGE_TARGET == 'master' } // PR target is master
                }
            }
                steps {
                     script {
                        if (fileExists('code-analyzer-results.html')) {
                             // Archive the analysis results
                            archiveArtifacts artifacts: 'code-analyzer-results.html', fingerprint: true
                            
                            publishHTML (target : [allowMissing: false,
                                                     alwaysLinkToLastBuild: true,
                                                     keepAll: true,
                                                     reportDir: 'reports',
                                                     reportFiles: 'code-analyzer-results.html',
                                                     reportName: 'Code Analyzer Report',
                                                     reportTitles: 'The Report'])
                            } else {
                                echo "No analyzer-results.csv file found, skipping archive."
                            }
                     }

                }
            }
    }
}
