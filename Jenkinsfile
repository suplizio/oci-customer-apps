pipeline {
    agent any
    stages {
        stage('Checkout and Deploy') {
            steps {
                script {
                    boolean executeDestroy = new Boolean(env.EXECUTE_DESTROY)
                    boolean executeApply = new Boolean(env.EXECUTE_APPLY)
                    def workspacePath = pwd()


                    git(url: 'git@github.com:suplizio/oci-customer-apps.git', branch: 'master', credentialsId: 'suplizio')

                    sh 'cd ${workspacePath}/terraform'

                    echo 'Executing terraform init...'
                    sh 'terraform init -input=false'

                    echo 'Executing terraform plan...'
                    sh 'terraform plan -lock=false -var display_name=${DISPLAY_NAME} -out=${WORKSPACE}/${PLAN_OUTPUT} -state=${WORKSPACE}/${STATE_INPUT}'


                    if (executeDestroy) {
                        echo 'Executing terraform destroy...'
                        sh 'terraform destroy -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${WORKSPACE}/${STATE_INPUT}'
                    }
                    if (executeApply) {
                        echo 'Executing terraform apply...'
                        sh 'terraform apply -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${WORKSPACE}/${STATE_INPUT}'
                    }
                }

            }
        }
        stage('Nginx Configure ') {
            steps {
                echo 'Running Ansible'

                sh 'ansible-playbook -i ${workspacePath}/${ANSIBLE_YML_DIR}/hosts.yml ${workspacePath}/${ANSIBLE_YML_DIR}/nginx_setup.yml'

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
        ANSIBLE_YML_DIR = 'ansible'
    }
}