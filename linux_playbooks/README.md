# Ansible Playbooks for Mac infra Linux VMs

This directory contains Ansible playbooks for the Linux machines in the MacStadium infrastructure.

They serve two purposes:

* Provisioning our vanilla VM images during a Packer build
* Keeping existing Linux VMs in the infrastructure set up with the proper user accounts for people on the team.

## When a new person joins the team

The `site.yml` playbook runs only the `users` role. Run this playbook to ensure that all the expected user accounts exist on all machines, and update their `authorized_keys` file from GitHub.

When someone new joins the team:

1. Add a new entry to the `users` key in the `travis-keychain` repository in `config/travis.macstadium-image-builder.yml`.
2. `$ rake update_users`

That's it! The new person should be able to ssh into any of the Linux boxes in MacStadium now.
