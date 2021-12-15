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
                git credentialsId: env.GIT_CREDENTIALS, url: 'https://github.com/JulianUmbhau/Corona_Vis_Shiny.git', branch: main
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
                echo "build app"
            }
        }
    }
    post {
        always {
            echo "always"
        }
    }

}