// CODE_CHANGES = getGitChanges()
pipeline {
    
    agent any
    environment {
        NEW_VERSION = "1.3.0"
        SERVER_CREDENTIALS = credentials("jenkins_tutorial_github")
        GIT_CREDENTIALS = credentials("jenkins_tutorial_github")
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
        stage("build") {
            when {
                expression {
                    env.BRANCH_NAME == "main"
                }
            }
        
            steps {
                sh "docker build -t coronavis ."
                echo "build app"
            }
        }
        stage("deploy") {
            steps {
                echo "deploying with secrets"
            }
        }
    }
    post {
        always {
            echo "always"
        }
    }

}