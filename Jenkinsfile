pipeline {
    agent any

    environment {
        IMAGE_NAME = "rajshreec/train-app"
        IMAGE_TAG  = "v${BUILD_NUMBER}"
        ASG_NAME   = "Train-schedule-Auto-scaling-group"
        LT_NAME    = "Train-app-launch-template"
    }

    stages {

        stage('Clone Repo') {
            steps {
                git branch: 'main', url: 'https://github.com/RJ-Chaudhari/High-availability-alb-asg-cicd-train-schedule-pipeline.git'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$IMAGE_TAG .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:$IMAGE_TAG'
            }
        }
stage('Create New Launch Template Version') {
    steps {
        sh """
        IMAGE_VERSION=${IMAGE_TAG}

        USER_DATA_BASE64=\$(echo '#!/bin/bash
set -e
apt update -y
apt install docker.io -y
systemctl enable docker
systemctl start docker
docker pull rajshreec/train-app:'"\$IMAGE_VERSION"'
docker run -d -p 80:3000 rajshreec/train-app:'"\$IMAGE_VERSION"'' | base64 -w 0)

        aws ec2 create-launch-template-version \
          --launch-template-name ${LT_NAME} \
          --source-version 1 \
           --launch-template-data "{\\"UserData\\":\\"\$USER_DATA_BASE64\\"}"
         
        """
    }
} 
          stage('Trigger ASG Instance Refresh') {
            steps {
                sh """
                aws autoscaling start-instance-refresh \
                --auto-scaling-group-name $ASG_NAME
                """
            }
        }
    }
}
