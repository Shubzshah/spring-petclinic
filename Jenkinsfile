pipeline {
    agent any
    environment {
        // Using the token created in JFrog and stored in Jenkins for authorization
        ARTIFACTORY_ACCESS_TOKENS = credentials('artifactory-access-token')
    }
    stages {
        stage('Clean Workspace') {
            steps {
                // Clean workspace before starting the build
                cleanWs()
            }
        }
        // stage('Clean Dependencies') {
        //     steps {
        //         // Clean Maven dependencies
        //         sh 'rm -rf ~/.m2/repository'
        //         sh 'rm -rf ~/.m2/caches'
        //     }
        // }
        stage('Checkout') {
            steps {
                // Check out source code from version control
                git branch: 'main', url: 'https://github.com/Shubzshah/spring-petclinic'
            }
        }
        stage('Compile') {
            steps {
                sh './mvnw compile -Dcheckstyle.skip -s settings.xml'
            }
        }
        stage('Test') {
            steps {
                sh './mvnw test -Dcheckstyle.skip -s settings.xml'
            }
        }
        stage('Build') {
            steps {
                sh './mvnw clean install -DskipTests -Dmaven.compiler.skip=true -Dcheckstyle.skip -s settings.xml'
            }
        }
        stage('Package') {
            steps {
                // This step creates an image and publishes the tar file containing docker image as an artifact
                sh 'docker build -t spring-petclinic .'
                sh 'docker save -o spring-petclinic.tar spring-petclinic:latest'
            }
            post {
                always {
                    // Publish archived artifacts
                    archiveArtifacts artifacts: 'spring-petclinic.tar', fingerprint: true
                }
            }
        }
        stage('Upload to Artifactory') {
            steps {
                // Uploading the .jar artifact to ArtiFactory
                sh '''
                    export UPLOAD_PATH=target/*.jar
                    curl -H "Authorization: Bearer ${ARTIFACTORY_ACCESS_TOKENS}" -X PUT "http://localhost:8081/artifactory/my-maven-local-releases/spring-petclinic/" -T $UPLOAD_PATH
                '''
            }
        }
    }
}