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
                    sh 'terraform init -input=false -no-color '

                    echo 'Executing terraform plan...'
                    sh 'terraform plan -lock=false -no-color -var display_name=${DISPLAY_NAME} -out=${WORKSPACE}/${PLAN_OUTPUT} -state=${WORKSPACE}/${STATE_INPUT}'

                    if (executeDestroy) {
                        echo 'Executing terraform destroy...'
                        sh 'terraform destroy -no-color  -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${WORKSPACE}/${STATE_INPUT}'
                    }
                    if (executeApply) {
                        echo 'Executing terraform apply...'
                        sh 'terraform apply -no-color -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${WORKSPACE}/${STATE_INPUT}'
                    }
                }
            }
        }
        stage('Ansible Configuration') {
            steps {
                script {
                    echo 'Prepare Ansible Host file..'
                    def output = sh returnStdout: true, script: 'terraform output -state=${WORKSPACE}/${STATE_INPUT} backend_public_ips'
                    def ips = output.tokenize(",")
                    def hostFile = pwd() + '/ansible/hosts.yml'
                    def cmd =""
                    for (i in ips) {
                        cmd = cmd + "$i:"
                    }
                    def readContent = readFile(hostFile).trim()
                    writeFile file: hostFile, text: readContent + cmd
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