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
                    sh 'terraform init -lock=true -no-color '

                    echo 'Executing terraform plan...'
                    sh 'terraform plan -lock=true -no-color -var display_name=${DISPLAY_NAME} -state=${STATE_FILE}'

                    if (executeDestroy) {
                        echo 'Executing terraform destroy...'
                        sh 'terraform destroy -lock=true -no-color  -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${STATE_FILE}'
                    }
                    if (executeApply) {
                        echo 'Executing terraform apply...'
                        sh 'terraform apply -lock=true -no-color -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${STATE_FILE}'
                    }
                }
            }
        }
        stage('Create Ansible config files') {
            steps {
                script {
                    echo 'Prepare Ansible Host file..'
                    def output = sh returnStdout: true, script: 'terraform output -state=${STATE_FILE} backend_public_ips'
                    def ips = output.tokenize("\\s*,\\s*")
                    def hostFile = pwd() + '${ANSIBLE_HOST_FILE}'
                    def cmd = "nginx-server:\n  hosts:\n"
                    cmd + "  hosts:\n"

                    println cmd

                    for (i in ips) {
                        def ip = i.trim() + ':\n'
                        cmd = cmd + "    $ip"
                    }
                    writeFile file: hostFile, text: cmd

                    println cmd

                }
            }
        }
        stage('Run Ansible Playbook') {
            steps {
                script {
                    echo 'Running Ansible Playbooks..'
                    def hostFile = pwd() + '${ANSIBLE_HOST_FILE}'
                    def playbook = pwd() + '${ANSIBLE_PLAYBOOK}'
                    sh 'ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i ' + hostFile + ' ' + playbook + ' '
                }
            }
        }
    }
    environment {
        DISPLAY_NAME = 'c1dev'
        STATE_FILE = '/var/lib/jenkins/workspace/tf_state_files/terraform.tfstate'
        EXECUTE_DESTROY = 'false'
        EXECUTE_APPLY = 'true'
        ANSIBLE_HOST_FILE = '/ansible/hosts.yml'
        ANSIBLE_PLAYBOOK = '/ansible/nginx_setup.yml'
    }
}
