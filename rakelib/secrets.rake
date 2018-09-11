desc 'Copy secrets for Ansible from Travis keychain'
task :secrets do
  sh 'trvs generate-config macstadium-image-builder ansible-secrets > linux_playbooks/secrets.yml'
end
