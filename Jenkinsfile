pipeline { 
    agent any 
    environment {
    }
    stages {
        stage('Build our website'){
            steps{
                sh "scripts/build.sh"
            }
        }

        stage('Run unit tests') {
            steps{
                sh "scripts/unit_tests.sh"
            }
        }

        stage('Deploy website') {
            steps{
                sh "scripts/deploy_website.sh"
            }
        }
    }
}