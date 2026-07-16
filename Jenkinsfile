pipeline {
    agent any

    // Use the managed Terraform installation
    tools {
        terraform 'terraform-1.14.1'
    }

    environment {
        AWS_ACCESS_KEY_ID = credentials('jcasc-aws-credentials-id')
        AWS_SECRET_ACCESS_KEY = credentials('jcasc-aws-credentials-id')
        AWS_DEFAULT_REGION = 'eu-central-1'
    }

    stages {
        stage('Tools validation') {
            steps {
                dir('terraform/aws') {
                    sh 'pwd'
                    sh 'terraform version'
                }
            }
        }
        stage('AWS Network') {
            steps {
                dir('terraform/aws/modules/network') {
                    sh 'pwd'
                    sh 'terraform init -lock-timeout=60s'
                    sh 'terraform validate'
                    sh 'terraform plan -lock-timeout=60s'
                    timeout(time: 10, unit: 'MINUTES') {
                        input message: 'Proceed?', ok: 'Yes'
                    }
                    sh 'terraform apply -lock-timeout=60s -auto-approve'
                }
            }
        }
    }
}