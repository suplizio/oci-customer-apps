pipeline {
    agent any
    stages {
        stage('Checkout and Deploy') {
            steps {
                script {
                    boolean executeDestroy = new Boolean(env.EXECUTE_DESTROY)
                    boolean executeApply = new Boolean(env.EXECUTE_APPLY)

                    git(url: 'git@github.com:suplizio/oci-customer-apps.git', branch: 'master', credentialsId: 'suplizio')

                    echo 'Executing terraform init...'
                    sh 'terraform init -input=false'

                    echo 'Executing terraform plan...'
                    sh 'terraform plan -lock=false -var display_name=${DISPLAY_NAME} -out=${WORKSPACE}/${PLAN_OUTPUT} -state=${WORKSPACE}/${STATE_INPUT}'

                    //sh 'terraform plan -lock=false -var display_name=${DISPLAY_NAME} -out=${WORKSPACE}/${PLAN_OUTPUT}'
                    if (executeDestroy) {
                        echo 'Executing terraform destroy...'
                        sh 'terraform destroy -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${WORKSPACE}/${STATE_INPUT}'
                    }
                    if (executeApply) {
                        echo 'Executing terraform apply...'
                        sh 'terraform apply -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${WORKSPACE}/${STATE_INPUT}'
                    }

                    echo 'Prepare Ansible Host file..'
                    def cmd = 'terraform output -state=${WORKSPACE}/${STATE_INPUT} backend_public_ips'

                    // Test commit message for flags
                    def publicIps = sh returnStdout: true, script: '${cmd}'
                    println publicIps
                }
            }
        }
        stage('Prepare Ansible Config files') {
            steps {
                script {
                    echo 'Unreacheable?'

                }

            }
        }
    }
    environment {
        DISPLAY_NAME = 'c1dev'
        PLAN_OUTPUT = 'plan/tfplan'
        WORKSPACE = '/var/lib/jenkins/workspace'
        STATE_INPUT = 'state/terraform.tfstate'
        EXECUTE_DESTROY = 'false'
        EXECUTE_APPLY = 'true'
        ANSIBLE = 'ansible'
    }
}
