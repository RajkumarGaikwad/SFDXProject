pipeline {
    
    agent any

    triggers {
        // Optional: Trigger on PRs automatically
        githubPullRequest() // or bitbucketPullRequest()
    }

    
    environment {
        PATH = "/opt/homebrew/bin:/usr/local/bin:${env.PATH}"
    }
    
    stages {

        stage('Check PR Target') {
            when {
                expression {
                    return !(env.CHANGE_ID && env.CHANGE_TARGET == 'master')
                }
            }
            steps {
                echo "Skipping build: Not a PR to master branch"
                script {
                    currentBuild.result = 'NOT_BUILT'
                    // Exit early
                    return
                }
            }
        }
    
            stage('Authenticate Salesforce Org') {
                steps {
                     withCredentials([file(credentialsId:'2579a42d-3efe-45a9-aeb2-7e07583c28ce', variable: 'jwt_key_file')]) {
                     sh 'sf org login jwt --client-id 3MVG9rZjd7MXFdLgA4ym8bhSwiFNIHiSqo_uLz66HyBrAfHWef6G4fDcd9RPeanyEsRxsKDwtvObwzNMloBA1 --username rajkumar.gaikwad3@gmail.com --jwt-key-file ${jwt_key_file} --alias my-hub-org --set-default --set-default-dev-hub'
                    }
                }
            }

        stage('Generate Delta') {
            steps {
                script {
                    
                    def targetBranch = 'master'
                    def sourceBranch = 'RajkumarGaikwad-patch-2'
                    
                    sh '''
                        echo "Generating delta between commits..."
                        git fetch origin master
                        git fetch origin RajkumarGaikwad-patch-2:RajkumarGaikwad-patch-2

                        git checkout RajkumarGaikwad-patch-2
                        
                        git diff --name-only origin/master RajkumarGaikwad-patch-2 | grep -E '\\.cls$|\\.trigger$|\\.apex$|\\.js$|\\.cmp$|\\.xml$|\\.html$' > delta-files.txt || true

                        echo "Changed Files:"
                        cat delta-files.txt || echo "No files found."
                    '''
                }
            }
        }

        stage('Run Salesforce Code Analyzer - Delta Files Only') {
            steps {
                script {
                    sh '''
                        if [ -s delta-files.txt ]; then
                            echo "Running SF Code Analyzer  on delta files..."
                            sf code-analyzer run --workspace $(cat delta-files.txt | tr '\\n' ',' | sed 's/,$//') --rule-selector all --view detail --output-file "code-analyzer-results.csv" --config-file "code-analyzer.yml"
                        else
                            echo "No delta files to scan."
                        fi
                    '''
                }
            }
        }
    

            stage('Archive Results') {
                steps {
                     script {
                        if (fileExists('code-analyzer-results.csv')) {
                             // Archive the analysis results
                            archiveArtifacts artifacts: 'code-analyzer-results.csv', fingerprint: true
                            } else {
                                echo "No analyzer-results.csv file found, skipping archive."
                            }
                     }

                }
            }
    }
}
