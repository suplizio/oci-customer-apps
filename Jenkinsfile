pipeline {
    agent any
    stages {
        stage('Checkout and Deploy') {
            steps {
                script {
                    boolean executeDestroy = new Boolean(env.EXECUTE_DESTROY)
                    boolean executeApply = new Boolean(env.EXECUTE_APPLY)
                    def stateFile = env.WORKSPACE + "/" + evn.STATE_FILE
                    def planFile = env.WORKSPACE + "/" + env.PLAN_FILE

                    git(url: 'git@github.com:suplizio/oci-customer-apps.git', branch: 'master', credentialsId: 'suplizio')

                    echo 'Executing terraform init...'
                    sh 'terraform init -input=false'

                    echo 'Executing terraform plan...'
                    sh 'terraform plan -lock=false -var display_name=${DISPLAY_NAME} -out=${planFile} -state=${stateFile}'


                    if (executeDestroy) {
                        echo 'Executing terraform destroy...'
                        sh 'terraform destroy -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${stateFile}'
                    }
                    if (executeApply) {
                        echo 'Executing terraform apply...'
                        sh 'terraform apply -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${stateFile}'
                    }
                }

            }
        }
        stage('Nginx Configure ') {
            steps {
                echo 'Running Ansible'
                sh 'terraform output backend_public_ips >> test.yml'
                //sh 'ansible-playbook -i ${workspacePath}/${ANSIBLE_YML_DIR}/hosts.yml ${workspacePath}/${ANSIBLE_YML_DIR}/nginx_setup.yml'
            }
        }
    }
    environment {
        DISPLAY_NAME = 'c1dev'
        WORKSPACE = '/var/lib/jenkins'
        PLAN_FILE = 'plan/tfplan'
        STATE_FILE = 'state/terraform.tfstate'
        EXECUTE_DESTROY = 'false'
        EXECUTE_APPLY = 'true'
        ANSIBLE_YML_DIR = 'ansible'
    }
}