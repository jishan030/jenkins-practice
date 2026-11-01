pipeline {
    agent { label 'linux-agent' }

    stages {
        stage('Where am I?') {
            steps {
                echo "Node: ${env.NODE_NAME}"
                sh 'pwd'
                sh 'whoami'
            }
        }
        stage('Checkout') {
            steps {
                echo 'Code Jenkins ne GitHub se le liya'
                sh 'ls -l'
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'chmod +x hello.sh'
                sh './hello.sh'
            }
        }
        stage('Test') {
            steps {
                echo 'Running tests...'
                sh 'test -f hello.sh && echo "Test passed: hello.sh mil gayi"'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying (abhi sirf demo)...'
            }
        }
    }

    post {
        success { echo 'Pipeline successful!' }
        failure { echo 'Pipeline failed!' }
    }
}
