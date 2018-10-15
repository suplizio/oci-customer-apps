pipeline {
  agent any
  boolean executeDestroy = new Boolean(env.EXECUTE_DESTROY)
  boolean executeApply = new Boolean(env.EXECUTE_APPLY)

  stages {

    stage('Checkout and Deploy') {
      steps {
        script {
          git(url: 'git@github.com:suplizio/oci-customer-apps.git', branch: 'master', credentialsId: 'suplizio')

          echo 'Executing terraform init...'
          sh 'terraform init -input=false -no-color '

          echo 'Executing terraform plan...'
          sh 'terraform plan -input=false -lock=false -no-color -var display_name=${DISPLAY_NAME}  -state=${WORKSPACE}/${STATE_INPUT} -out=${WORKSPACE}/${PLAN_OUTPUT}'

          if (executeDestroy) {
            echo 'Executing terraform destroy...'
            sh 'terraform destroy -input=false -no-color -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${WORKSPACE}/${STATE_INPUT}'
          }
          if (executeApply) {
            echo 'Executing terraform apply...'
            sh 'terraform apply -input=false -no-color -auto-approve -lock=false -var display_name=${DISPLAY_NAME} -state=${WORKSPACE}/${STATE_INPUT}'
          }
        }

      }
    }
    stage('Create Ansible config files') {
      steps {
        script {
          if (executeApply) {
            echo 'Prepare Ansible Host file..'
            def output = sh returnStdout: true, script: 'terraform output -state=${WORKSPACE}/${STATE_INPUT} backend_public_ips'
            def ips = output.tokenize("\\s*,\\s*")
            def hostFile = pwd() + '/ansible/hosts.yml'
            def cmd = "app:\n  hosts:\n"
            cmd + "  hosts:\n"
            for (i in ips) {
              def ip = i.trim() + ':\n'
              cmd = cmd + "    $ip"
            }
            writeFile file: hostFile, text: cmd
          } else {
            echo 'Skipping preparing Ansible Host file..'
          }
        }

      }
    }
    stage('Run Ansible Playbook') {
      steps {
        script {
          if (executeApply) {
            echo 'Running Ansible Playbooks..'
            def playbook = pwd() + '/ansible/nginx.yml'
            sh 'ansible-playbook ' + playbook + ' '
          } else {
            echo 'Skipping Ansible Playbooks..'
          }
        }

      }
    }
  }
  environment {
    DISPLAY_NAME = 'c1dev'
    WORKSPACE = '/var/lib/jenkins/workspace/tf_files'
    PLAN_OUTPUT = 'tfplan'
    STATE_INPUT = 'terraform.tfstate'
    EXECUTE_DESTROY = 'false'
    EXECUTE_APPLY = 'true'
  }
}