# macOS Configuration Role

This role should run early in the playbook and is responsible for setting up various kinds of system configuration.

## Variables

None.

## Tasks

* Enables passwordless `sudo` for the Travis user
* Copies shell configuration files for the Travis user
* Sets the timezone
* Disables sleep and screen lock
* Disables automatic software updates
* Enables remote login
