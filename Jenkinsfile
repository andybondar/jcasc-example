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
        stage('Keypair') {
            steps {
                dir('terraform/aws/modules/keypair') {
                    withCredentials([file(credentialsId: 'jcasc_id_rsa.pub', variable: 'TF_VAR_public_key_path')]) {
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
        stage('Network') {
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
        stage('Elastic IP') {
            steps {
                dir('terraform/aws/modules/eip') {
                    withCredentials([string(credentialsId: 'jcasc_domain_name', variable: 'TF_VAR_domain')]) {
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
        stage('EC2') {
            steps {
                dir('terraform/aws/modules/ec2') {
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