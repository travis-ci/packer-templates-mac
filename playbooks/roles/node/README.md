# Node Role

This role installs NVM and multiple versions of Node.js.

## Variables

* `nvm_dir`: The directory where NVM should be installed. (optional, default: /Users/travis/.nvm)
* `nvm_version`: The Git revision of NVM that should be used. (optional, default: v0.33.2)
* `node_versions`: The list of versions of Node.js to install. (optional, see `defaults/main.yml` for default list)

## Tasks

* Installs NVM
* Installs Node.js versions
