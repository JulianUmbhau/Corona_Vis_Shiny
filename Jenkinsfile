pipeline {
    agent any
    environment {
        NEW_VERSION = "1.3.0"
        SERVER_CREDENTIALS = credentials("global-umbhau")
    }

    stages {

        stage("checkout") {
            
            steps {
                echo "checkout branch"
                echo "Building version ${NEW_VERSION}"
                
            }
        }

        stage("init") {
            steps {
                script {
                    gv = load "script.groovy"
                }
            }
        }

        stage("build") {
            when {
                expression {
                    env.BRANCH_NAME == "main" || BRANCH_NAME == "dev"
                }
            }
        
            steps {
                script {
                    gv.buildApp()
                }
                echo "build app"
            }
        }

        stage("test") {
            when {
                expression {
                    params.executeTest == true
                }
            }
            steps {
                echo "testing"
            }
        }

        stage("deploy") {
            steps {
                echo "deploy app"
                // withCredentials([
                //    usernamePassword(credentials: 'global-umbhau', usernameVariable: USER, passwordVariable: PWD)
                // ]) {
                //    echo "${USER}"
                //}
                echo "deploying version ${params.VERSION}"
            }

        }

    }
    post {
        always {
            echo "always"
        }
    }
