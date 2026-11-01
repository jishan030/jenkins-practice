pipeline {
    agent { label 'linux-agent' }

    stages {
        stage('Node Info') {
            steps {
                echo "Running on node: ${env.NODE_NAME}"
                sh 'pwd'
                sh 'whoami'
            }
        }
        stage('Checkout') {
            steps {
                echo 'Source code checked out from GitHub'
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
                sh 'test -f hello.sh && echo "Test passed: hello.sh found"'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploy stage (demo only)'
            }
        }
    }

    post {
        success { echo 'Pipeline completed successfully' }
        failure { echo 'Pipeline failed' }
    }
}
