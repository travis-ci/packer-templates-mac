desc 'Update user accounts on the Mac infra Linux VMs'
task update_users: [:secrets] do
  sh 'ansible-playbook -i linux_playbooks/linux_hosts linux_playbooks/site.yml'
end
