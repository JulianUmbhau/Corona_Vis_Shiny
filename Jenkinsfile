// CODE_CHANGES = getGitChanges()
pipeline {
    
    agent any
    environment {
        NEW_VERSION = "1.3.0"
        SERVER_CREDENTIALS = credentials("jenkins_tutorial_github")
    }
    parameters {
        choice(name: "VERSION", choices:["1.1.0","1.2.0"], description: "parameters test")
        booleanParam(name: "executeTest", defaultValue: true, description: "test execution param")
    }

    stages {

        stage("checkout") {
            
            steps {
                sh '''
                    echo "checkout branch"
                '''
                sh '''
                    echo "Building version ${NEW_VERSION}"
                '''
                
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
                echo "deploying version ${params.VERSION}"
            }

        }

    }
    post {
        always {
            echo "always"
        }
    }

}