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
        stage('Create Ansible config files') {
            steps {
                script {
                    echo 'Prepare Ansible Host file..'
                    def output = sh returnStdout: true, script: 'terraform output -state=${WORKSPACE}/${STATE_INPUT} backend_public_ips'
                    def ips = output.tokenize("\\s*,\\s*")
                    def hostFile = pwd() + '/${ANSIBLE_DIR}/${ANSIBLE_HOSTS}'
                    def cmd = "nginx-server:\n  hosts:\n"
                    cmd + "  hosts:\n"
                    for (i in ips) {
                        def ip = i.trim() + ':\n'
                        cmd = cmd + "    $ip"
                    }
                    writeFile file: hostFile, text: cmd
                }
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                script {
                    echo 'Running Ansible Playbooks..'
                    def hostFile = pwd() + '/${ANSIBLE_DIR}/${ANSIBLE_HOSTS}'
                    def playbook = pwd() + '/${ANSIBLE_DIR}/${ANSIBLE_PLAYBOOK}'
                    sh 'ansible-playbook -i ' + hostFile + ' ' + playbook + ' '
                }
            }
        }
    }
    environment {
        DISPLAY_NAME = 'c1dev'
        PLAN_OUTPUT = 'plan/tfplan'
        WORKSPACE = '/var/lib/jenkins/workspace'
        STATE_INPUT = 'state/terraform.tfstate'
        EXECUTE_DESTROY = 'true'
        EXECUTE_APPLY = 'true'
        ANSIBLE_DIR= 'ansible'
        ANSIBLE_PLAYBOOK= 'nginx_setup.yml'
        ANSIBLE_HOSTS = 'hosts.yml'
    }
}